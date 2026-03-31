# New Area Workflow

Use this workflow when adding a new major repo area or component, such as:

- reverse proxy guidance
- built-in TLS support documentation
- alternative storage layouts
- additional maintenance or observability workflows

## Goals

- add the new area without breaking the current source-of-truth structure
- keep human docs, agent docs, verification, and review coverage aligned
- avoid undocumented one-off growth

## Workflow

1. Define the boundary.
   Decide whether the new area belongs in the current server-only Compose scope
   or should remain external to this repo.
2. Add or update human docs in `Docs/`.
3. Add directory `README.md` coverage if a new visible directory is created.
4. Add or extend agent context in `agents/context/`.
5. Add new rules only if the area introduces true non-negotiables.
6. Update `AGENTS.md`, `agents/*/README.md`, and `Docs/README.md` if routing
   changes.
7. Extend verification if the new area adds a structural check worth running by
   default.
8. Add a decision entry in `Docs/decisions/` if the new area establishes a
   durable repo choice.
9. Run the correct review workflow.
10. Log review-driven follow-up changes separately.
