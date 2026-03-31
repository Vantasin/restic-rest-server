# Deprecation And Migration Rules

Use these rules when renaming, replacing, removing, or splitting any
operator-facing or agent-facing contract.

## Applies To

- environment variables
- Compose service names
- storage paths and persistence semantics
- human doc locations and names
- agent routing paths

## Non-Negotiables

- do not remove or rename a contract silently
- when a rename affects operators, document the migration path in the canonical
  human docs
- when a rename affects agent routing, update `AGENTS.md` and the relevant
  `agents/*/README.md` files in the same change
- remove stale references across docs, rules, workflows, and READMEs

## Migration Expectations

- state what changed
- state what replaces the old contract
- state whether the change is manual or automatic
- say whether a running deployment needs `docker compose up -d`, a new `.env`,
  or other operator action
