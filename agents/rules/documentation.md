# Documentation Rules

## Canonical Sources

- human-facing behavior, setup, and operations documentation belongs in
  `Docs/` and `README.md`
- agent-facing process guidance belongs in `agents/`

## Required Human Doc Updates

Update human docs when a change touches:

- `docker-compose.yml` behavior or deployment flow
- `env.example` variables, defaults, or examples
- storage paths or persistence semantics
- auth defaults, bind addresses, or exposure model
- repo verification or Git hook behavior

## Required Agent Updates

Update `agents/` when a change touches:

- review procedure
- change logging expectations
- documentation workflow
- repo boundaries or future architecture assumptions

## Writing Guidance

- link to the canonical human doc instead of duplicating it in `agents/`
- keep agent docs concise and operational
- prefer one clear owner document per topic
