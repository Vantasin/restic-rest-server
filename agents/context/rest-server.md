# Rest Server Context

This repo deploys the official `restic/rest-server` container image.

## Current Assumptions

- authentication stays enabled by default
- the official image reads `.htpasswd` from `/data/.htpasswd` unless changed
- extra flags are passed through the image's `OPTIONS` environment variable
- the default repo access model is `--append-only --private-repos`
- the default public access path is through Nginx Proxy Manager on the shared
  `npm_proxy` network

## Operator Consequences

- users must be created with `docker compose exec rest-server create_user ...`
- repository URLs must begin with the username when `--private-repos` is used
- repository initialization is a client task, not a server bootstrap task
- transport security is expected to be handled by Nginx Proxy Manager unless
  the operator intentionally chooses a different model

## Where To Update Docs

- deployment flow: `README.md`, `Docs/DEPLOYMENT.md`
- access model and defaults: `Docs/CONFIGURATION.md`, `Docs/SECURITY.md`
- day-two commands: `Docs/OPERATIONS.md`
