# Git Hooks Directory

This directory contains the repo-managed Git hooks used to catch fast,
mechanical consistency problems before a commit is created.

## Purpose

These hooks are intentionally lightweight. They enforce local safety rules and
complement the review workflows in [`../agents/`](../agents/README.md).

## Files

- [`pre-commit`](./pre-commit): blocks secret-bearing local env files, checks
  staged diff safety, and runs repo-wide verification

## Install

Enable the hooks for the current clone:

```bash
make install-hooks
```

This runs:

```bash
git config core.hooksPath githooks
```

## Relationship To `make verify`

`pre-commit` is commit-path enforcement. `make verify` is the manual repo-wide
consistency pass.
