#!/usr/bin/env bash
# Install the small toolset needed to provision a Mac.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='01-tools.sh'
step_description='Step 1/7 — NEW Mac: install development and credential-transfer tools.'
start_step "${1:-}"
mac_only
if ! xcode-select -p >/dev/null 2>&1; then
  echo 'Next: run xcode-select --install, finish the installer, then rerun this step.'
  exit 2
fi
if ! command -v brew >/dev/null; then
  echo 'Next: install Homebrew from https://brew.sh/, then rerun this step.'
  open https://brew.sh/
  exit 2
fi
brew bundle --file "$step_dir/Brewfile"
if [[ ! -d /Applications/Tailscale.app ]]; then brew install --cask tailscale; fi
echo 'Ready: tools and Tailscale are installed.'
next_step 02-sign-in.sh
