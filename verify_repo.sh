#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

usage() {
  cat <<'EOF'
Usage: ./verify_repo.sh [all|shell|readmes|compose|diff|diff-cached]

Default: all

Checks:
- diff:        git diff --check (working tree)
- diff-cached: git diff --cached --check (index)
- shell:       zsh syntax checks for repo shell scripts and hooks
- readmes:     ensure each visible repo directory has a README.md
- compose:     render docker compose config with env.example if docker compose is available
EOF
}

check_diff() {
  echo "[verify] git diff --check (working tree)"
  git diff --check
}

check_diff_cached() {
  echo "[verify] git diff --cached --check (index)"
  git diff --cached --check
}

check_shell() {
  echo "[verify] zsh syntax"

  local file
  local -a shell_files=(
    "verify_repo.sh"
    "githooks/pre-commit"
  )

  for file in $shell_files; do
    [[ -f "$file" ]] || continue
    zsh -n "$file"
  done
}

check_readmes() {
  echo "[verify] directory README coverage"

  local dir segment
  local skip_dir
  local -a missing_readmes

  for dir in ${(f)"$(find . -type d | sort)"}; do
    [[ "$dir" == "." ]] && continue

    skip_dir=false
    for segment in ${(s:/:)dir}; do
      [[ -z "$segment" || "$segment" == "." ]] && continue
      if [[ "$segment" == .* ]]; then
        skip_dir=true
        break
      fi
    done

    [[ "$skip_dir" == true ]] && continue
    [[ -f "$dir/README.md" ]] || missing_readmes+=("$dir")
  done

  if (( ${#missing_readmes[@]} > 0 )); then
    echo "ERROR: missing README.md in visible directories:" >&2
    printf '%s\n' "${missing_readmes[@]}" | sed 's/^/  - /' >&2
    return 1
  fi
}

check_compose() {
  echo "[verify] docker compose config"

  if ! command -v docker >/dev/null 2>&1; then
    echo "[verify] skip: docker is not installed"
    return 0
  fi

  if ! docker compose version >/dev/null 2>&1; then
    echo "[verify] skip: docker compose v2 is not available"
    return 0
  fi

  docker compose --env-file env.example config >/dev/null
}

run_target() {
  case "$1" in
    diff) check_diff ;;
    diff-cached) check_diff_cached ;;
    shell) check_shell ;;
    readmes) check_readmes ;;
    compose) check_compose ;;
    all)
      check_diff
      check_diff_cached
      check_shell
      check_readmes
      check_compose
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      echo "ERROR: unknown verify target: $1" >&2
      usage >&2
      return 1
      ;;
  esac
}

if (( $# == 0 )); then
  run_target all
else
  typeset target
  for target in "$@"; do
    run_target "$target"
  done
fi
