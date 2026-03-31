# Agent Review Workflow

Run this review after core changes to the repo's agent layer:

- `AGENTS.md`
- `agents/rules/`
- `agents/workflows/`
- `agents/context/`
- agent routing structure

## Goals

- keep agent guidance internally consistent
- keep `AGENTS.md` thin and aligned with `agents/`
- preserve the boundary between human docs in `Docs/` and agent docs in
  `agents/`
- avoid stale paths and duplicate guidance

## Review Sequence

1. Read `agents/rules/core.md`, `agents/rules/documentation.md`, and
   `agents/context/repo-map.md`.
2. Check that `AGENTS.md` points to current files only.
3. Check that rules, workflows, and context describe distinct responsibilities.
4. Confirm agent docs point back to canonical human docs where needed.
5. Run the relevant checks from `agents/rules/verification.md`.

## What To Look For

- stale paths
- duplicated human-ops guidance inside `agents/`
- conflicting rules or workflow steps
- missing review or verification expectations after structure changes

## Output Expectations

- lead with findings, ordered by severity
- call out drift and ambiguity explicitly
- if review causes edits, log them with `change-logging.md` as review-driven
