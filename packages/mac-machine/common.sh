#!/usr/bin/env bash
# Shared guidance for the numbered, human-run setup scripts.
set -euo pipefail
umask 077
step_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
step_script="$0"
step_usage=""
step_description=""
trap 'echo "Stopped. Fix the error above, then rerun this step: $step_script" >&2' ERR
# Homebrew may have been installed before its shell setup was activated.
if ! command -v brew >/dev/null; then export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"; fi
fail() { echo "$*" >&2; exit 2; }
need() { command -v "$1" >/dev/null || fail "Missing $1. Next: run $step_dir/01-tools.sh, then retry this step."; }
start_step() {
  if [[ "${1:-}" == --help || "${1:-}" == -h ]]; then
    echo "$step_usage"
    echo "$step_description"
    exit 0
  fi
  echo "$step_description"
}
next_step() { printf '\nNext, on the NEW Mac:\n  '; printf '%q ' "$step_dir/$1" "${@:2}"; printf '\n'; }
mac_only() { [[ "$(uname -s)" == Darwin ]] || fail 'Run this step on the new Mac.'; }
