#!/usr/bin/env bash
# Sign into Tailscale and GitHub before cloning private projects.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='02-sign-in.sh'
step_description='Step 2/7 — NEW Mac: sign into Tailscale and GitHub.'
start_step "${1:-}"
mac_only
need jq
need gh
open -a Tailscale
if ! status="$("$step_dir/machine" tailscale-status 2>/dev/null)"; then
  echo 'Next: finish Tailscale sign-in and system-extension approval, then rerun this step.'
  exit 2
fi
if [[ "$(printf '%s' "$status" | jq -r '.BackendState')" != Running ]]; then
  echo 'Next: finish sign-in in the Tailscale app, approve its system extension, then rerun this step.'
  exit 2
fi
gh auth status >/dev/null 2>&1 || gh auth login --web --git-protocol https
gh auth setup-git
echo 'Ready: Tailscale and GitHub are signed in.'
echo 'Before transferring: enable Taildrop for your tailnet and use the same Tailscale account on both Macs.'
echo 'Enable Tailscale Sharing in System Settings > General > Login Items & Extensions > Sharing.'
next_step 03-sutro.sh
