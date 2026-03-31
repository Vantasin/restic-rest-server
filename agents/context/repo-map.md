# Repo Map

## Root Entry Points

- `README.md`: main human onboarding page
- `docker-compose.yml`: deployed stack definition
- `env.example`: tracked configuration template
- `.env`: local runtime state, never commit
- `Makefile`: convenience targets for hooks and verification
- `verify_repo.sh`: repo-wide local checks
- `AGENTS.md`: thin router into `agents/`

## Human Docs

- `Docs/README.md`: doc map
- `Docs/DEPLOYMENT.md`: first deployment and updates
- `Docs/CONFIGURATION.md`: env contract
- `Docs/STORAGE.md`: persistent storage layout
- `Docs/SECURITY.md`: security model and guardrails
- `Docs/OPERATIONS.md`: operational commands, verification, and hooks
- `Docs/decisions/`: durable repo decisions

## Agent Docs

- `agents/rules/`: invariants and constraints
- `agents/workflows/`: how to review and extend the repo
- `agents/context/`: current architecture and source-of-truth mapping

## Repo-Managed Hooks

- `githooks/pre-commit`: commit-path enforcement for local-only files and
  structural verification
- `githooks/README.md`: install and purpose
