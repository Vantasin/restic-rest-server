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
   sudo chown "$USER":"$USER" /tank/docker/compose/restic-rest-server
   sudo chmod 755 /tank/docker/compose/restic-rest-server
   sudo chown root:root /tank/docker/data/restic-rest-server
   sudo chmod 700 /tank/docker/data/restic-rest-server
   git clone https://github.com/Vantasin/restic-rest-server.git /tank/docker/compose/restic-rest-server
   cd /tank/docker/compose/restic-rest-server
   ```

   Keep the Compose dataset operator-owned because it holds the Git working
   tree and local `.env`. Keep the data dataset root-owned because it stores
   live bind-mounted service state.

   If you already use GitHub SSH keys, the SSH clone URL is also fine.

2. Copy the tracked env template to local runtime state.

   ```bash
   cp env.example .env
   chmod 600 .env
   ```

3. Edit `.env`.

   At minimum, review:

   - `REST_SERVER_DATA_ROOT`
   - `REST_SERVER_OPTIONS`

   For a curated guide to the supported `rest-server` flags used by this repo,
   see [`Docs/CONFIGURATION.md`](./Docs/CONFIGURATION.md).

4. Ensure the shared proxy network exists.

   If your Nginx Proxy Manager stack is already deployed, this should already
   exist.

   ```bash
   docker network inspect npm_proxy >/dev/null 2>&1 || docker network create npm_proxy
   ```

5. Start the stack.

   ```bash
   docker compose up -d
   ```

   With the current bind mount configuration, Docker Compose will create the
   bind source path if it does not already exist.

6. Add the proxy host in Nginx Proxy Manager.

   If you use the matching public Nginx Proxy Manager stack, see:
   <https://github.com/Vantasin/Nginx-Proxy-Manager.git>

   Use:

   - Domain Name: your backup hostname such as `backup.example.com`
   - Scheme: `http`
   - Forward Hostname / IP: `restic-rest-server`
   - Forward Port: `8000`
   - SSL: your certificate with `Force SSL` enabled

7. Create the first HTTP auth user inside the running container.

   ```bash
   docker compose exec rest-server create_user backup
   ```

8. Initialize the first repository from a restic client.

   With the default `--private-repos` option, the repository path must start
   with the username. The example assumes HTTPS is terminated by a reverse
   proxy:

   ```bash
   restic -r "rest:https://backup:<PASSWORD>@backup.example.com/backup/laptop" init
   ```

## Client Onboarding

The server-side login and the restic repository password are separate.

- Rest-server username/password:
  server-managed access credentials stored in `.htpasswd`
- Restic repository password:
  client-managed encryption password known to the client

Typical onboarding flow for one client:

1. Server admin creates the rest-server user:

   ```bash
   docker compose exec rest-server create_user backup
   ```

2. Server admin gives the client:

   - the hostname, for example `backup.example.com`
   - the rest-server username, for example `backup`
   - the rest-server password that was set during `create_user`

3. Client initializes its repository and chooses its own restic repository
   password:

   ```bash
   restic -r "rest:https://backup:<SERVER_PASSWORD>@backup.example.com/backup/laptop" init
   ```

4. Client reuses that repository URL for backup, snapshots, restore, and other
   restic operations.

Multiple users are supported. With `--private-repos`, each user is limited to
paths under its own username prefix, for example:

- `backup/laptop`
- `backup/server-a`
- `alice/workstation`

## Access Modes

The access model is controlled by `REST_SERVER_OPTIONS` in `.env`.

Default append-only mode:

```dotenv
REST_SERVER_OPTIONS="--path /data/repos --append-only --private-repos"
```

Use this when:

- clients should be able to back up and restore
- clients should not be able to delete snapshots or prune repository data
- the server should act as an append-only backup target

Client-managed maintenance mode:

```dotenv
REST_SERVER_OPTIONS="--path /data/repos --private-repos"
```

Use this when:

- each client should run its own `forget` / `prune`
- each client is trusted to manage repository retention
- you accept that a compromised client can delete its own snapshots and data

`--private-repos` should stay enabled in both modes unless you intentionally
want to remove per-user path isolation.

## Default Behavior

- Uses the official `restic/rest-server` image pinned through `env.example`
- If you intentionally use Watchtower, setting local `.env` to
  `REST_SERVER_IMAGE_TAG=latest` is acceptable
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
