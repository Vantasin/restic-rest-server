# Restic REST Server Docker Compose Repo

Self-contained deployment repo for a server-side `restic/rest-server` stack.
This repo is intentionally scoped to Docker Compose deployment and operation of
the REST server. macOS client automation belongs elsewhere.

The default examples in this repo assume a ZFS-backed Linux server with pool
`tank`, Compose clones under `/tank/docker/compose`, and persistent service
data under `/tank/docker/data`.

The default network model assumes a separate Nginx Proxy Manager stack handles
public HTTPS and SSL termination on a shared external Docker network.
Reference stack:
<https://github.com/Vantasin/Nginx-Proxy-Manager.git>

## Quick Start

1. Clone the repo onto the Linux host.

   ```bash
   sudo zfs create -p tank/docker/compose/restic-rest-server
   sudo zfs create -p tank/docker/data/restic-rest-server
   sudo chown -R "$USER":"$USER" /tank/docker/compose/restic-rest-server
   git clone <REPO_URL> /tank/docker/compose/restic-rest-server
   cd /tank/docker/compose/restic-rest-server
   ```

2. Copy the tracked env template to local runtime state.

   ```bash
   cp env.example .env
   chmod 600 .env
   ```

3. Edit `.env`.

   At minimum, review:

   - `REST_SERVER_DATA_ROOT`
   - `REST_SERVER_OPTIONS`

4. Ensure the shared proxy network exists.

   If your Nginx Proxy Manager stack is already deployed, this should already
   exist.

   ```bash
   docker network inspect npm_proxy >/dev/null 2>&1 || docker network create npm_proxy
   ```

5. Create the host storage path from `.env`.

   The example below uses the default `REST_SERVER_DATA_ROOT`.

   ```bash
   sudo mkdir -p /tank/docker/data/restic-rest-server/repos
   sudo chmod 700 /tank/docker/data/restic-rest-server
   ```

6. Start the stack.

   ```bash
   docker compose up -d
   ```

7. Add the proxy host in Nginx Proxy Manager.

   If you use the matching public Nginx Proxy Manager stack, see:
   <https://github.com/Vantasin/Nginx-Proxy-Manager.git>

   Use:

   - Domain Name: your backup hostname such as `backup.example.com`
   - Scheme: `http`
   - Forward Hostname / IP: `restic-rest-server`
   - Forward Port: `8000`
   - SSL: your certificate with `Force SSL` enabled

8. Create the first HTTP auth user inside the running container.

   ```bash
   docker compose exec rest-server create_user backup
   ```

9. Initialize the first repository from a restic client.

   With the default `--private-repos` option, the repository path must start
   with the username. The example assumes HTTPS is terminated by a reverse
   proxy:

   ```bash
   restic -r "rest:https://backup:<PASSWORD>@backup.example.com/backup/laptop" init
   ```

   If you are intentionally using plain HTTP on a trusted network, use
   `rest:http://...` instead.

## Default Behavior

- Uses the official `restic/rest-server` image pinned through `env.example`
- Keeps authentication enabled by default
- Joins the shared `npm_proxy` Docker network for reverse-proxy access
- Stores persistent data on a host path bind mount, not inside the repo
- Starts in `--append-only --private-repos` mode by default
- Keeps `.env` local and gitignored; `env.example` is the tracked source of
  truth

## Common Commands

Start or refresh the stack:

```bash
docker compose up -d
```

Show logs:

```bash
docker compose logs -f rest-server
```

Restart the service:

```bash
docker compose restart rest-server
```

Update after a pull:

```bash
git pull
docker compose pull
docker compose up -d
```

Run repo verification:

```bash
make verify
```

Enable repo-managed Git hooks for this clone:

```bash
make install-hooks
```

## Human Docs

Use the root README for the first deployment, then follow the detailed docs in
[`Docs/`](./Docs/README.md):

- [`Docs/DEPLOYMENT.md`](./Docs/DEPLOYMENT.md)
- [`Docs/CONFIGURATION.md`](./Docs/CONFIGURATION.md)
- [`Docs/STORAGE.md`](./Docs/STORAGE.md)
- [`Docs/SECURITY.md`](./Docs/SECURITY.md)
- [`Docs/OPERATIONS.md`](./Docs/OPERATIONS.md)
- [`Docs/decisions/README.md`](./Docs/decisions/README.md)

## Agent Docs

`Docs/` is human-facing only. The agent-facing layer lives in
[`AGENTS.md`](./AGENTS.md) and [`agents/`](./agents/README.md).

## Repository Notes

- Docker Compose V2 is assumed.
- The default examples assume your ZFS pool is named `tank`; replace `tank` if
  the host uses a different pool name.
- The default reverse proxy assumption is a separate Nginx Proxy Manager stack
  on the shared `npm_proxy` Docker network.
- The matching public Nginx Proxy Manager reference repo is:
  <https://github.com/Vantasin/Nginx-Proxy-Manager.git>
- The service is not published on a host port by default; Nginx Proxy Manager
  should proxy to `restic-rest-server:8000` over Docker networking.
- Exposing the service directly on an untrusted network without TLS is not a
  safe default; see [`Docs/SECURITY.md`](./Docs/SECURITY.md).
