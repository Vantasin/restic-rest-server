# Configuration

The tracked configuration model is template-first:

- [`../env.example`](../env.example) is the Git-tracked template
- `.env` is local runtime state for the current deployment

Never commit `.env`.

## Environment Variables

### `REST_SERVER_IMAGE_TAG`

Pinned `restic/rest-server` image tag for the Compose stack.

Default:

```dotenv
REST_SERVER_IMAGE_TAG=0.14.0
```

Recommended use:

- keep the tracked default pinned in `env.example`
- if you intentionally use Watchtower for unattended image updates, it is
  reasonable to set local `.env` to `REST_SERVER_IMAGE_TAG=latest`

Trade-off:

- pinned tags keep repo state and runtime version aligned
- `latest` fits auto-update workflows better but allows runtime drift ahead of
  the repo

### `REST_SERVER_CONTAINER_NAME`

Stable container name used for operator commands such as user management. With
the default reverse-proxy model, this is also the hostname Nginx Proxy Manager
should forward to on the shared Docker network.

Default:

```dotenv
REST_SERVER_CONTAINER_NAME=restic-rest-server
```

### `REST_SERVER_DATA_ROOT`

Host path bind-mounted to `/data` inside the container. This path persists:

- `.htpasswd`
- repository data under `repos/`

Default:

```dotenv
REST_SERVER_DATA_ROOT=/tank/docker/data/restic-rest-server
```

See [`STORAGE.md`](./STORAGE.md).

### `REST_SERVER_PASSWORD_FILE`

Path inside the container for the `.htpasswd` file used by the official image.

Default:

```dotenv
REST_SERVER_PASSWORD_FILE=/data/.htpasswd
```

### `REST_SERVER_OPTIONS`

Extra rest-server flags passed through the official image's `OPTIONS`
environment variable.

Default:

```dotenv
REST_SERVER_OPTIONS="--path /data/repos --append-only --private-repos"
```

Meaning:

- `--path /data/repos`: keep repositories under a dedicated subdirectory
- `--append-only`: allow new backups but prevent deletion/modification through
  the REST API
- `--private-repos`: require each repository path to begin with the username

Keep this value as one quoted string in `.env`.

Recommended mode choices:

Append-only mode, recommended default:

```dotenv
REST_SERVER_OPTIONS="--path /data/repos --append-only --private-repos"
```

Client-managed maintenance mode:

```dotenv
REST_SERVER_OPTIONS="--path /data/repos --private-repos"
```

Trade-off:

- append-only mode protects repository contents from normal client-side delete
  and prune operations
- client-managed maintenance mode allows each authenticated client to run its
  own `forget` / `prune`

In both modes, `--private-repos` keeps each user limited to its own repository
path prefix.

Optional app-level repository size limit:

```dotenv
REST_SERVER_OPTIONS="--path /data/repos --append-only --private-repos --max-size 500000000000"
```

Notes:

- `--max-size` belongs inside `REST_SERVER_OPTIONS`; there is no separate env
  variable for it in this repo
- upstream documents `--max-size` as the maximum size of a repository in bytes
- treat it as an application-level repository limit, not as a replacement for
  ZFS dataset quotas
- if you want hard host-side storage boundaries per user, document and enforce
  them with ZFS datasets and quotas instead

## Curated `rest-server` Flags Reference

This repo passes `rest-server` flags through `REST_SERVER_OPTIONS`. Keep the
value as one quoted string in `.env`.

### Default Flags In This Repo

| Flag | Default In Repo | What It Does | When To Use It | Caveat |
| --- | --- | --- | --- | --- |
| `--path /data/repos` | Yes | Stores repositories under `/data/repos` instead of the image default path. | Keep it for this repo. | Changing it affects storage docs and existing repo paths. |
| `--append-only` | Yes | Allows new backups but blocks deletion and modification through the REST API. | Use for append-only backup targets. | Clients cannot run `forget` / `prune` through this endpoint. |
| `--private-repos` | Yes | Restricts each user to repository paths that begin with the username. | Keep it for multi-user isolation. | Removing it changes the access-control model. |

### Optional Flags That Fit This Repo

| Flag | Default In Repo | What It Does | When To Use It | Caveat |
| --- | --- | --- | --- | --- |
| `--max-size <bytes>` | No | Sets the maximum size of a repository in bytes. | Use when you want an app-level per-repo limit. | Applies per repository, not per user across multiple subrepositories. |
| `--prometheus` | No | Exposes Prometheus metrics at `/metrics`. | Use if you run Prometheus scraping for this stack. | Add auth planning before enabling in a shared environment. |
| `--prometheus-no-auth` | No | Disables auth on `/metrics`. | Use only on a trusted internal monitoring path. | Not a safe default on broadly reachable networks. |
| `--group-accessible-repos` | No | Makes repositories accessible to the filesystem group. | Use only if you intentionally operate with shared host group access. | Not needed in the current root-owned data-path model. |
| `--log <file>` | No | Writes HTTP request logs to a file. | Use if container stdout logging is not enough. | File logging needs host-path planning and rotation. |
| `--debug` | No | Enables debug logging. | Use temporarily while diagnosing issues. | Too noisy for a normal default. |

### Flags That Change The Deployment Model

| Flag | Default In Repo | What It Does | When To Use It | Caveat |
| --- | --- | --- | --- | --- |
| `--no-auth` | No | Disables `.htpasswd` authentication. | Rarely appropriate. | Breaks the repo's user-management and private-repo model. |
| `--proxy-auth-username <header>` | No | Trusts an upstream proxy header as the username. | Use only if you intentionally move auth to a trusted proxy. | Changes the security model and requires proxy hardening. |
| `--tls` | No | Enables TLS in `rest-server`. | Use only if you intentionally terminate TLS in the container. | This repo defaults to TLS termination in Nginx Proxy Manager. |
| `--tls-cert <path>` / `--tls-key <path>` | No | Points `rest-server` at certificate and key files. | Use only with in-container TLS. | Requires cert/key lifecycle management in this repo. |
| `--tls-min-ver 1.2|1.3` | No | Sets the minimum TLS version for in-container TLS. | Use only with in-container TLS. | Not relevant to the default NPM-terminated model. |
| `--listen <addr>` | No | Changes the listen address inside the container. | Usually leave at the image default `:8000`. | The current Compose stack assumes the container listens on port `8000`. |
| `--no-verify-upload` | No | Skips upload integrity verification. | Only for very constrained hardware after deliberate review. | Upstream explicitly warns against enabling it casually. |

Upstream reference for the full current flag list:
<https://github.com/restic/rest-server>

## What Is Intentionally Not In `.env`

- repository passwords used by restic clients
- full Nginx Proxy Manager stack configuration
- Docker host port publishing choices for the REST server
- TLS certificate management
- host firewall rules

Those concerns remain outside this repo's base Compose stack.

## Configuration Change Checklist

When changing tracked defaults in [`../env.example`](../env.example):

1. Update this file.
2. Update [`../README.md`](../README.md) if operator workflow changes.
3. Update [`OPERATIONS.md`](./OPERATIONS.md) or [`SECURITY.md`](./SECURITY.md)
   if behavior changes.
