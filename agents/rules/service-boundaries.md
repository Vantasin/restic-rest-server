# Service Boundaries Rules

This repo is for server-side Restic REST deployment only.

## Non-Negotiables

- do not add macOS backup automation, launchd jobs, or client-side scheduling
  here
- keep the base stack focused on Docker Compose deployment of the REST server
- keep `Docs/` human-only and `agents/` agent-only
- keep persistent backup data outside the repo clone

## Allowed Growth

- reverse proxy guidance
- TLS and certificate-mount guidance
- storage-layout guidance
- additional server-side maintenance workflows

## Guardrails

- if a new area introduces another service, document why it belongs in this
  repo and update the source-of-truth matrix
- if a concern can stay external to the base stack, prefer documenting the
  integration instead of hard-wiring it into `docker-compose.yml`
