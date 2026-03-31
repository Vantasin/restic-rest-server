# Verification Rules

Choose validation based on what changed and report what was or was not run.

## Always

- prefer `make verify` as the baseline local verification pass
- run `git diff --check` before finishing

## Review Triggers

- run `agents/workflows/agent-review.md` after core changes to `AGENTS.md` or
  `agents/`
- run `agents/workflows/repo-review.md` after core changes to Compose,
  templates, verification, storage, security, or human docs
- if either review leads to follow-up edits, log them with
  `agents/workflows/change-logging.md`

## When Shell Logic Changes

- run `zsh -n` on edited shell scripts such as `verify_repo.sh` and
  `githooks/pre-commit`

## When Compose Or Env Changes

- verify that `docker compose --env-file env.example config` still renders when
  Docker Compose V2 is available locally
- verify that related human docs still match the configured defaults

## When Review Findings Are Reported

- prefer concrete evidence such as file references, commands run, exit codes,
  and rendered config checks where available
