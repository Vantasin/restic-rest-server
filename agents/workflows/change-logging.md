# Change Logging Workflow

Use this workflow when summarizing work, writing commit context, or recording
operational changes.

## Record

- what changed
- why it changed
- what operator-visible behavior changed
- what verification was run
- what was not verified
- whether the change came from the main implementation pass or a review-driven
  follow-up

## Include When Relevant

- image tags
- published ports
- storage paths
- auth or access-model changes
- whether the change affected tracked templates only or live runtime state too
- which review workflow triggered a follow-up (`agent-review` or `repo-review`)

## Do Not Include

- secrets
- raw credentials
- unnecessary command output when a short explanation is enough
