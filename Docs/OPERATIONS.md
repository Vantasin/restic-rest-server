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
curl -I http://127.0.0.1:8000/
```

Notes:

- a `401 Unauthorized` response is expected when auth is enabled and the server
  is reachable
- `docker network inspect npm_proxy` confirms the shared reverse-proxy network
  exists on the host
- the `curl` example uses the default bind address and port; adjust it to match
  your `.env`
- Nginx Proxy Manager should reach the service at `restic-rest-server:8000`
  over Docker networking, not through the host loopback address

## User Management

Create a user:

```bash
docker compose exec rest-server create_user backup
```

Delete a user:

```bash
docker compose exec rest-server delete_user backup
```

These commands update the `.htpasswd` file inside the bind-mounted data path.

## Backup Repository Initialization

The server deployment does not initialize client repositories on its own. From
a restic client, use a repository URL that matches the configured access model.

Default pattern with `--private-repos`:

```bash
restic -r "rest:https://backup:<PASSWORD>@backup.example.com/backup/laptop" init
```

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
