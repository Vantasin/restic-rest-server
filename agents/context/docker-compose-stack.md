# Docker Compose Stack Context

The current stack is intentionally small: one `rest-server` service defined at
the repo root.

## Current Shape

- image: `restic/rest-server:${REST_SERVER_IMAGE_TAG}`
- bind mount: `${REST_SERVER_DATA_ROOT}:/data`
- shared external proxy network: `npm_proxy`
- no host port publishing in the default stack
- auth file path: `${REST_SERVER_PASSWORD_FILE}`
- extra rest-server flags: `${REST_SERVER_OPTIONS}`
- default tracked data path: `/tank/docker/data/restic-rest-server`
- default human-doc examples assume a ZFS-backed host with pool `tank`
- default human-doc examples assume a separate Nginx Proxy Manager stack
  terminates TLS and forwards to this container over Docker networking

## Design Intent

- keep the deployment entry point at `docker-compose.yml`
- prefer explicit env variables over hidden defaults
- keep persistent data outside the repo clone
- integrate with the external reverse proxy without bundling it into this repo
- let future reverse proxy or TLS additions remain additive rather than
  entangled with the base stack

## Drift Risks

- docs describing defaults that no longer match `env.example`
- accidental reintroduction of host port publishing without an intentional
  deployment-model change
- changing proxy-network assumptions without updating deployment/security docs
- switching away from bind-mounted persistent storage without updating storage
  guidance
- ZFS/pool/path examples drifting away from the tracked defaults in the repo
