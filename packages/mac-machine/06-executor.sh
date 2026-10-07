#!/usr/bin/env bash
# Help the human install and open Executor Desktop.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='06-executor.sh [sutro-checkout]'
step_description='Step 6/7 — NEW Mac: install and open Executor Desktop.'
start_step "${1:-}"
mac_only
checkout="${1:-$HOME/workspace/sutro}"
if [[ ! -x /Applications/Executor.app/Contents/Resources/executor/executor ]]; then
  open 'https://executor.sh/#run-it'
  echo 'Next: choose the Mac download for your processor, install Executor in Applications, then rerun this step.'
  exit 2
fi
open -a Executor
open 'https://exc.binder.sh/default/integrations/sutro-dec'
echo 'Ready: local Executor opened. Finish Cloudflare sign-in in the browser.'
next_step 07-check.sh "$checkout"
