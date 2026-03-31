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

### `REST_SERVER_CONTAINER_NAME`

Stable container name used for operator commands such as user management.

Default:

```dotenv
REST_SERVER_CONTAINER_NAME=restic-rest-server
```

### `REST_SERVER_BIND_ADDRESS`

Host IP for the published port.

Recommended values:

- `127.0.0.1` when using a same-host reverse proxy for TLS
- `0.0.0.0` only when you intentionally want direct network exposure

### `REST_SERVER_PUBLISHED_PORT`

Host port mapped to container port `8000`.

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

## What Is Intentionally Not In `.env`

- repository passwords used by restic clients
- reverse proxy configuration
- TLS certificate management
- host firewall rules

Those concerns remain outside this repo's base Compose stack.

## Configuration Change Checklist

When changing tracked defaults in [`../env.example`](../env.example):

1. Update this file.
2. Update [`../README.md`](../README.md) if operator workflow changes.
3. Update [`OPERATIONS.md`](./OPERATIONS.md) or [`SECURITY.md`](./SECURITY.md)
   if behavior changes.
