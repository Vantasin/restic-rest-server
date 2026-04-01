# Deployment

This repo is designed for the simplest server workflow:

1. Clone the repo.
2. Copy `env.example` to `.env`.
3. Edit `.env`.
4. Run `docker compose up -d`.
5. Pull updates and reload the stack later.

## Prerequisites

- Linux server
- Docker Engine
- Docker Compose V2
- Git
- optional but assumed in the default examples: ZFS on Linux with pool `tank`
- Nginx Proxy Manager or another reverse proxy if the service will be exposed
  over HTTPS

Reference stack for the default reverse-proxy model:
<https://github.com/Vantasin/Nginx-Proxy-Manager.git>

## First Deployment

Create the ZFS datasets and clone the repo:

```bash
sudo zfs create -p tank/docker/compose/restic-rest-server
sudo zfs create -p tank/docker/data/restic-rest-server
sudo chown -R "$USER":"$USER" /tank/docker/compose/restic-rest-server
git clone <REPO_URL> /tank/docker/compose/restic-rest-server
cd /tank/docker/compose/restic-rest-server
```

If the host uses a different ZFS pool name, replace `tank` in the examples.

Create local runtime config:

```bash
cp env.example .env
chmod 600 .env
```

Edit `.env` and set:

- `REST_SERVER_DATA_ROOT`
- `REST_SERVER_OPTIONS`

Ensure the shared proxy network exists:

If your Nginx Proxy Manager stack is already deployed, it should already exist.

```bash
docker network inspect npm_proxy >/dev/null 2>&1 || docker network create npm_proxy
```

Create the host storage path:

The example below uses the default `REST_SERVER_DATA_ROOT`.

```bash
sudo mkdir -p /tank/docker/data/restic-rest-server/repos
sudo chmod 700 /tank/docker/data/restic-rest-server
```

Start the service:

```bash
docker compose up -d
```

Configure Nginx Proxy Manager:

If you are following the matching public Nginx Proxy Manager repo, use:
<https://github.com/Vantasin/Nginx-Proxy-Manager.git>

- Domain Name: your public backup hostname such as `backup.example.com`
- Scheme: `http`
- Forward Hostname / IP: `restic-rest-server`
- Forward Port: `8000`
- SSL: choose the certificate for the hostname and enable `Force SSL`

Create the first HTTP auth user:

```bash
docker compose exec rest-server create_user backup
```

## Repository Initialization Expectations

This repo deploys the server. Repository initialization still happens from a
restic client.

With the default `--private-repos` option, repository URLs must begin with the
username segment:

```bash
restic -r "rest:https://backup:<PASSWORD>@backup.example.com/backup/laptop" init
```

Additional repositories for the same user can be created beneath that prefix,
for example `/backup/server-a` and `/backup/server-b`.

## Update Workflow

Pull repo changes:

```bash
git pull
```

Pull a newer image if the tracked tag changed:

```bash
docker compose pull
```

Recreate the service with the current repo state:

```bash
docker compose up -d
```

## Related Docs

- [`CONFIGURATION.md`](./CONFIGURATION.md)
- [`STORAGE.md`](./STORAGE.md)
- [`SECURITY.md`](./SECURITY.md)
- [`OPERATIONS.md`](./OPERATIONS.md)
