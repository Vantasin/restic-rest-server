# Operations

This file covers day-two operations for the deployed stack and the repo's local
verification behavior.

## Stack Commands

Start or recreate the stack:

```bash
docker compose up -d
```

Pull a newer image:

```bash
docker compose pull
```

If the deployment intentionally uses Watchtower, local `.env` may set
`REST_SERVER_IMAGE_TAG=latest` instead of the pinned tracked default from
`env.example`.

Restart the service:

```bash
docker compose restart rest-server
```

Stop the stack:

```bash
docker compose down
```

Show logs:

```bash
docker compose logs -f rest-server
```

Show service state:

```bash
docker compose ps
```

Render the Compose config with the current `.env`:

```bash
docker compose config
```

## Health And Status Checks

Useful lightweight checks:

```bash
docker compose ps
docker compose logs --tail=100 rest-server
docker network inspect npm_proxy >/dev/null
```

Notes:

- `docker network inspect npm_proxy` confirms the shared reverse-proxy network
  exists on the host
- Nginx Proxy Manager should reach the service at `restic-rest-server:8000`
  over Docker networking
- for troubleshooting, prefer `docker compose logs`, Portainer logs, and
  temporary in-container probes over host-published ports

## User Management

Create a user:

```bash
docker compose exec rest-server create_user backup
```

Delete a user:

```bash
docker compose exec rest-server delete_user backup
```

Reset or change a user's server password by running `create_user` again for the
same username:

```bash
docker compose exec rest-server create_user backup
```

These commands update the `.htpasswd` file inside the bind-mounted data path.

If you use per-user ZFS datasets and quotas, create the dataset before running
the client's first `restic init` so the repository lands in the dataset
mountpoint instead of a plain directory.

Credential model:

- rest-server username/password:
  server-managed access credentials
- restic repository password:
  client-managed encryption password

## Backup Repository Initialization

The server deployment does not initialize client repositories on its own. From
a restic client, use a repository URL that matches the configured access model.

Default pattern with `--private-repos`:

```bash
export RESTIC_REPOSITORY="rest:https://backup.example.com/backup/laptop"
export RESTIC_REST_USERNAME="backup"
read -rs "RESTIC_REST_PASSWORD?REST server password: "; echo
restic init
```

Keep the repository URL free of inline Basic Auth credentials. `RESTIC_REST_*`
variables are the safer default for operator examples.

If the server is in append-only mode, clients can back up and restore through
that endpoint but cannot run `forget` / `prune` there.

If the server is in client-managed maintenance mode, clients can run
`forget` / `prune` through the same endpoint. That changes the risk model for
compromised clients, but it does not replace host-side quota planning.

## Repo Verification

Run the fast repo-wide verification layer with:

```bash
make verify
```

That runs:

- `git diff --check`
- `git diff --cached --check`
- `zsh -n` for repo-managed shell files
- visible-directory `README.md` coverage
- `docker compose --env-file env.example config` when Docker Compose V2 is
  available locally

The default verification path does not require network access or a running
Docker daemon.

## Repo-Managed Git Hook

Enable the repo-managed hook for the current clone:

```bash
make install-hooks
```

The `pre-commit` hook:

- blocks `.env` and `.env.*`
- blocks `.DS_Store`
- runs `git diff --cached --check`
- runs `./verify_repo.sh shell readmes compose`

## Update Workflow

After pulling repo changes:

```bash
git pull
docker compose pull
docker compose up -d
```

## Related Docs

- [`../githooks/README.md`](../githooks/README.md)
- [`CONFIGURATION.md`](./CONFIGURATION.md)
- [`SECURITY.md`](./SECURITY.md)
