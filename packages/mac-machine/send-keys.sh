#!/usr/bin/env bash
# Send one explicitly selected key file to the new Mac.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='send-keys.sh <age-recipient> <new-mac-tailscale-name> <source-.env.keys>'
step_description='EXISTING Mac — encrypt the selected key file and send it to the new Mac.'
start_step "${1:-}"
[[ $# == 3 ]] || fail "Usage: $step_usage. Use the recipient printed by step 4; the key file is usually ~/workspace/sutro/.env.keys."
command -v age >/dev/null || fail 'Missing age. Next, on this existing Mac: brew install age; then rerun the sender command.'
"$step_dir/machine" send "$3" "$1" "$2"
echo 'Ready: encrypted transfer completed.'
echo 'Next, on the NEW Mac: run the 05-import-keys.sh command printed in step 4.'
