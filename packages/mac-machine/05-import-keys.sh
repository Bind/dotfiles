#!/usr/bin/env bash
# Import the encrypted download and check dotenvx decryption.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='05-import-keys.sh [encrypted-download] [sutro-checkout]'
step_description='Step 5/7 — NEW Mac: install the transferred keys and verify decryption.'
start_step "${1:-}"
need mise
download="${1:-$HOME/Downloads/sutro-keys.age}"
checkout="${2:-$HOME/workspace/sutro}"
if [[ ! -e "$checkout/.env.keys" && ! -L "$checkout/.env.keys" ]]; then
  [[ -f "$download" ]] || fail 'Transfer file not found. Next: finish the Taildrop transfer or pass the actual downloaded filename to this step.'
  "$step_dir/machine" receive "$download" "$checkout"
else
  echo 'Keys already exist; checking them without replacing them.'
fi
[[ -f "$checkout/.env.keys" && ! -L "$checkout/.env.keys" ]] || fail 'Next: inspect the existing .env.keys; it must be a regular file.'
[[ "$(stat -f '%Lp' "$checkout/.env.keys")" == 600 ]] || fail 'Next: chmod 600 the existing .env.keys, then rerun this step.'
"$step_dir/machine" verify-env "$checkout"
echo 'You can now delete sutro-keys.age from Downloads.'
next_step 06-executor.sh "$checkout"
