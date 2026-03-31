# Docker Compose Stack Context

The current stack is intentionally small: one `rest-server` service defined at
the repo root.

## Current Shape

- image: `restic/rest-server:${REST_SERVER_IMAGE_TAG}`
- bind mount: `${REST_SERVER_DATA_ROOT}:/data`
- published port: `${REST_SERVER_BIND_ADDRESS}:${REST_SERVER_PUBLISHED_PORT}:8000`
- auth file path: `${REST_SERVER_PASSWORD_FILE}`
- extra rest-server flags: `${REST_SERVER_OPTIONS}`

## Design Intent

- keep the deployment entry point at `docker-compose.yml`
- prefer explicit env variables over hidden defaults
- keep persistent data outside the repo clone
- let future reverse proxy or TLS additions remain additive rather than
  entangled with the base stack

## Drift Risks

- docs describing defaults that no longer match `env.example`
- changing the bind address or published port without updating security docs
- switching away from bind-mounted persistent storage without updating storage
  guidance
