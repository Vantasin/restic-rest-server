# Template Integrity Rules

Use these rules when changing tracked templates or local runtime config flows.

## Source Of Truth

- `env.example` is the Git-tracked source of truth for deployment defaults
- `.env` is local runtime state and must not replace the tracked template as
  the canonical edit target

## Non-Negotiables

- do not commit populated secrets
- do not document `.env` as if it were meant to be tracked
- if tracked defaults change, update the human docs that explain them
- if tracked path defaults or storage examples change, update the related agent
  context that describes the current deployment layout

## Drift Risks

- updating `.env` instructions without updating `env.example`
- updating `env.example` without updating `Docs/CONFIGURATION.md`
- changing deployment defaults without updating the root README
- changing tracked `tank`/path defaults without updating storage-related
  context and docs
