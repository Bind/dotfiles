#!/usr/bin/env bash
# Generate the receiving Mac's age identity and show the sender's next command.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='04-recipient.sh [sutro-checkout]'
step_description="Step 4/7 — NEW Mac: create this Mac's credential-transfer recipient."
start_step "${1:-}"
need age-keygen
checkout="${1:-$HOME/workspace/sutro}"
[[ -d "$checkout/.git" ]] || fail 'Sutro is missing. Next: run 03-sutro.sh first.'
recipient="$("$step_dir/machine" recipient)"
echo "Public recipient: $recipient"
echo 'The private identity stays on this Mac. Compare the public recipient on both screens.'
echo 'Next, on the EXISTING Mac, from its updated dotfiles checkout:'
echo 'Replace NEW_MAC_TAILSCALE_NAME with the new Mac name shown in Tailscale.'
printf '  packages/mac-machine/send-keys.sh %q NEW_MAC_TAILSCALE_NAME ~/workspace/sutro/.env.keys\n' "$recipient"
echo 'Then return to the new Mac for step 5. The received file will be in Downloads.'
next_step 05-import-keys.sh "$HOME/Downloads/sutro-keys.age" "$checkout"
