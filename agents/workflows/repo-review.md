# Repo Review Workflow

Run this review after core repository-function changes, including:

- `docker-compose.yml`
- `env.example`
- `verify_repo.sh`
- `githooks/pre-commit`
- `Makefile`
- `README.md`
- human docs in `Docs/`

## Goals

- find behavioral regressions first
- keep deployment workflow, configuration defaults, and docs aligned
- catch drift between Compose, templates, verification, and operator guidance
- protect the server-only boundary of the repo

## Review Sequence

1. Read `agents/context/repo-map.md` and the touched context files.
2. Read the relevant human docs in `README.md` and `Docs/`.
3. Inspect changed implementation, templates, and docs together.
4. Check whether ports, paths, auth assumptions, update flow, and storage
   examples still match.
5. Run the relevant checks from `agents/rules/verification.md`.

## What To Look For

- secrets or local runtime state being committed
- Compose values or examples drifting away from `env.example`
- operator workflow drift between root README and detailed docs
- security claims that no longer match actual defaults
- storage-path drift or accidental in-repo persistence
- ZFS or `tank/docker/{compose,data}` examples drifting away from current
  tracked defaults
- hook or verification behavior no longer matching the docs

## Output Expectations

- lead with findings, ordered by severity
- include file references and concrete evidence where relevant
- if review causes edits, log them with `change-logging.md` as review-driven
