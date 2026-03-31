# Documentation Workflow

Use this workflow when implementation changes require doc updates.

## Sequence

1. Identify the canonical human doc in `Docs/` or `README.md`.
2. Update the human doc first.
3. Update `env.example` if tracked defaults or examples changed.
4. Update `agents/` only if workflows, rules, or component context changed.
5. Verify that links and terminology remain consistent across touched files.

## Mapping

- deployment flow: `README.md`, `Docs/DEPLOYMENT.md`
- env and defaults: `Docs/CONFIGURATION.md`
- persistent data layout: `Docs/STORAGE.md`
- security posture: `Docs/SECURITY.md`
- day-two operations, hooks, and verification: `Docs/OPERATIONS.md`

## Documentation Expectations

- human docs explain operator behavior and usage
- agent docs explain how to work on the repo
- link to the canonical human doc instead of restating it in `agents/`
