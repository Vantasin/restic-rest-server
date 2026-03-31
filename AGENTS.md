# Repository Guidelines

`Docs/` contains human-readable deployment and operations documentation.
`agents/` contains agent-facing rules, workflows, and repo context. Keep this
file thin and use it as a router.

## Read Order

1. `agents/rules/core.md`
2. `agents/context/repo-map.md`
3. `agents/context/source-of-truth-matrix.md`
4. The relevant files in `agents/context/`
5. The relevant files in `agents/workflows/`

## Agent References

- `agents/rules/core.md`
- `agents/rules/documentation.md`
- `agents/rules/verification.md`
- `agents/rules/template-integrity.md`
- `agents/rules/deprecation-and-migration.md`
- `agents/rules/service-boundaries.md`
- `agents/workflows/review.md`
- `agents/workflows/agent-review.md`
- `agents/workflows/repo-review.md`
- `agents/workflows/documentation.md`
- `agents/workflows/change-logging.md`
- `agents/workflows/new-area.md`
- `agents/context/repo-map.md`
- `agents/context/source-of-truth-matrix.md`
- `agents/context/docker-compose-stack.md`
- `agents/context/rest-server.md`
- `agents/context/storage-and-volumes.md`
- `agents/context/future-expansion.md`

## Canonical Human Docs

- `README.md`
- `Docs/DEPLOYMENT.md`
- `Docs/CONFIGURATION.md`
- `Docs/STORAGE.md`
- `Docs/SECURITY.md`
- `Docs/OPERATIONS.md`
- `Docs/decisions/README.md`

## Repo-Wide Non-Negotiables

- Never commit `.env` or populated secrets.
- Keep `env.example` as the tracked configuration template.
- Keep `Docs/` human-facing and `agents/` agent-facing.
- Do not mix client automation or host-specific backup scripts into this repo.
