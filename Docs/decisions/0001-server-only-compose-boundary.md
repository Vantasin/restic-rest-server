# 0001 Server-Only Compose Boundary

- Status: accepted
- Date: 2026-03-31

## Context

This repo exists to deploy and operate a Restic REST server via Docker Compose.
There is already separate Restic automation elsewhere for macOS client backup
behavior.

Without an explicit boundary, server deployment concerns, client automation,
and mixed human/agent instructions would drift together and make the repo
harder to operate.

## Decision

This repo will:

- stay server-only
- keep Docker Compose deployment at the repo root
- use tracked templates such as `env.example` for Git-managed defaults
- treat `.env` as local runtime state
- keep human docs in `Docs/`
- keep agent-only rules, workflows, and context in `agents/`

## Consequences

- client-specific backup automation does not belong here
- storage, reverse proxy, and service-growth guidance can be added later
  without changing the repo's operator entry point
- review and verification can stay fast because the repo focuses on one
  deployment surface
