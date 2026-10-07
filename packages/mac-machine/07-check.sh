#!/usr/bin/env bash
# Check remote credentials without depending on the CLI's health probe.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='07-check.sh [sutro-checkout]'
step_description='Step 7/7 — NEW Mac: verify authenticated hosted Executor access.'
start_step "${1:-}"
checkout="${1:-$HOME/workspace/sutro}"
need mise
[[ -f "$checkout/.env.keys" ]] || fail 'Keys are missing. Next: run 05-import-keys.sh, then retry this step.'
"$step_dir/machine" doctor "$checkout"
echo 'Ready: this Mac can decrypt its Sutro environment and read the hosted Executor API.'
echo 'Next: finish the local-app hosted connection using the instructions from the Executor chat.'
echo 'Verify it there with a read-only DEC model-info call. This check does not configure that connection.'
