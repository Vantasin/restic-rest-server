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

## First Deployment

Clone the repo:

```bash
git clone <REPO_URL> /srv/restic-rest-server-compose
cd /srv/restic-rest-server-compose
```

Create local runtime config:

```bash
cp env.example .env
chmod 600 .env
```

Edit `.env` and set:

- `REST_SERVER_BIND_ADDRESS`
- `REST_SERVER_PUBLISHED_PORT`
- `REST_SERVER_DATA_ROOT`
- `REST_SERVER_OPTIONS`

Create the host storage path:

The example below uses the default `REST_SERVER_DATA_ROOT`.

```bash
sudo mkdir -p /srv/restic-rest-server/repos
sudo chmod 700 /srv/restic-rest-server
```

Start the service:

```bash
docker compose up -d
```

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

For direct HTTP on a trusted network only:

```bash
restic -r "rest:http://backup:<PASSWORD>@backup.example.com:8000/backup/laptop" init
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
