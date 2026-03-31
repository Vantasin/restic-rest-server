# Source Of Truth Matrix

Use this matrix to decide where changes belong, which docs must stay aligned,
and what minimum verification should run.

| Area | Implementation / Source Files | Canonical Human Docs | Agent Context / Rules | Minimum Verification |
| --- | --- | --- | --- | --- |
| Compose deployment stack | `docker-compose.yml` | `README.md`, `Docs/DEPLOYMENT.md`, `Docs/OPERATIONS.md`, `Docs/SECURITY.md` | `agents/context/docker-compose-stack.md`, `agents/context/rest-server.md`, `agents/rules/service-boundaries.md` | `make verify`, `docker compose --env-file env.example config` when available |
| Tracked env contract | `env.example` | `Docs/CONFIGURATION.md`, `README.md`, `Docs/SECURITY.md` | `agents/context/source-of-truth-matrix.md`, `agents/rules/template-integrity.md` | `make verify` |
| Storage model | `docker-compose.yml`, `env.example` | `Docs/STORAGE.md`, `Docs/DEPLOYMENT.md` | `agents/context/storage-and-volumes.md`, `agents/context/docker-compose-stack.md`, `agents/rules/service-boundaries.md` | `make verify` |
| Security posture | `docker-compose.yml`, `env.example` | `Docs/SECURITY.md`, `README.md` | `agents/context/rest-server.md`, `agents/rules/service-boundaries.md` | `make verify`, repo review |
| Verification and hooks | `verify_repo.sh`, `githooks/pre-commit`, `Makefile` | `Docs/OPERATIONS.md`, `githooks/README.md` | `agents/rules/verification.md`, `agents/workflows/repo-review.md` | `make verify`, `zsh -n verify_repo.sh`, `zsh -n githooks/pre-commit` |
| Agent guidance layer | `AGENTS.md`, `agents/` | `Docs/README.md` for human doc map only | `agents/workflows/agent-review.md`, `agents/rules/core.md` | `make verify`, agent review |

## Notes

- `env.example` is the tracked source of truth for deployment defaults.
- `.env` is local runtime state and must not become the canonical edit target.
- current human-doc examples assume the live server's `tank/docker/{compose,data}`
  layout, but that is a tracked default rather than a repo-wide invariant.
- current network examples assume the external `npm_proxy` network and same-host
  Nginx Proxy Manager TLS termination, but those are tracked defaults rather
  than repo-wide invariants.
- If a change spans multiple rows, update every affected human doc and run both
  relevant review workflows when needed.
