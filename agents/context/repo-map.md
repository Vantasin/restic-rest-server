# Repo Map

## Root Entry Points

- `README.md`: main human onboarding page
- `docker-compose.yml`: deployed stack definition
- `env.example`: tracked configuration template
- `.env`: local runtime state, never commit
- `Makefile`: convenience targets for hooks and verification
- `verify_repo.sh`: repo-wide local checks
- `AGENTS.md`: thin router into `agents/`

## Default Deployment Layout

- repo clone path in examples: `/tank/docker/compose/restic-rest-server`
- persistent data path in examples: `/tank/docker/data/restic-rest-server`
- shared reverse-proxy network in examples: `npm_proxy`
- default public HTTPS path: external Nginx Proxy Manager forwarding to
  `restic-rest-server:8000`
- default stack exposure: no host-published service port
- these are current tracked defaults, not universal hard requirements

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
