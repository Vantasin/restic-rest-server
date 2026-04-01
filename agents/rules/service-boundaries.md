# Service Boundaries Rules

This repo is for server-side Restic REST deployment only.

## Non-Negotiables

- do not add macOS backup automation, launchd jobs, or client-side scheduling
  here
- keep the base stack focused on Docker Compose deployment of the REST server
- keep `Docs/` human-only and `agents/` agent-only
- keep persistent backup data outside the repo clone

## Allowed Growth

- reverse proxy guidance and documented integration with the external Nginx
  Proxy Manager stack
- TLS and certificate-mount guidance
- storage-layout guidance
- additional server-side maintenance workflows

## Guardrails

- if a new area introduces another service, document why it belongs in this
  repo and update the source-of-truth matrix
- if a concern can stay external to the base stack, prefer documenting the
  integration instead of hard-wiring it into `docker-compose.yml`
- joining the shared external proxy network is acceptable; vendoring the full
  Nginx Proxy Manager stack into this repo is not
- do not reintroduce host port publishing for the REST server unless the human
  docs and deployment model are intentionally changed in the same work
