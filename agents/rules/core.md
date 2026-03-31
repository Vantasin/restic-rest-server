# Core Rules

## Scope Split

- `Docs/` is for human-readable deployment and operations documentation.
- `agents/` is for agent-only rules, workflows, and context.
- `AGENTS.md` must stay thin and route agents into `agents/`.

## Repository Safety

- never commit `.env` or populated secrets
- treat `env.example` as the tracked source of truth for deployment defaults
- do not silently change auth posture, storage paths, bind addresses, or
  append-only/private-repo defaults without updating docs

## Change Hygiene

- update canonical human docs when operator-visible behavior changes
- update `agents/` only when repo rules, workflows, or architecture context
  change
- after core agent-layer changes, run the agent review workflow
- after core repository-function changes, run the repo review workflow
- if a review produces follow-up changes, log them with the change-logging
  workflow

## Future Expansion

- keep this repo server-only
- keep Docker Compose deployment at the repo root
- add new service-adjacent areas deliberately, not by mixing in client tooling
