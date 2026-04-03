# Rest Server Context

This repo deploys the official `restic/rest-server` container image.

## Current Assumptions

- authentication stays enabled by default
- the official image reads `.htpasswd` from `/data/.htpasswd` unless changed
- extra flags are passed through the image's `OPTIONS` environment variable
- the default repo access model is `--append-only --private-repos`
- the default public access path is through Nginx Proxy Manager on the shared
  `npm_proxy` network
- rest-server access credentials and restic repository passwords are separate

## Operator Consequences

- users must be created with `docker compose exec rest-server create_user ...`
- repository URLs must begin with the username when `--private-repos` is used
- human-facing client examples should prefer `RESTIC_REST_USERNAME` /
  `RESTIC_REST_PASSWORD` over inline `user:pass@` repository URLs
- repository initialization is a client task, not a server bootstrap task, and
  should point to the external `restic-rest-client` repo
- the server repo's client-facing contract is limited to the base per-user
  URL pattern, the username, and the server password
- transport security is expected to be handled by Nginx Proxy Manager unless
  the operator intentionally chooses a different model
- host-local access is not part of the default stack; troubleshooting should
  assume Portainer logs, `docker compose logs`, or temporary in-container
  probes
- changing `REST_SERVER_OPTIONS` changes whether clients are append-only backup
  users or full self-maintaining repo users
- `Docs/CONFIGURATION.md` contains the curated repo-specific flags table for
  `REST_SERVER_OPTIONS`; do not duplicate the full upstream help text elsewhere

## Where To Update Docs

- deployment flow: `README.md`, `Docs/DEPLOYMENT.md`
- access model and defaults: `Docs/CONFIGURATION.md`, `Docs/SECURITY.md`
- day-two commands: `Docs/OPERATIONS.md`
