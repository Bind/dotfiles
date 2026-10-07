# Show machine bootstrap commands.
[default]
default:
  @just --list

# Begin numbered setup on the new Mac (prints the first step).
mac-setup:
  packages/mac-machine/machine setup

# Generate the public recipient and show the existing Mac's sender command.
mac-recipient checkout="":
  packages/mac-machine/04-recipient.sh {{quote(checkout)}}

# Check scripts and exercise transfers with fake credentials only.
check:
  bash -n packages/mac-machine/machine
  shellcheck packages/mac-machine/machine
  bash -c 'for script in packages/mac-machine/*.sh; do bash -n "$script"; done'
  shellcheck --source-path=SCRIPTDIR packages/mac-machine/*.sh
  node --check packages/mac-machine/verify-env.cjs
  node --check packages/mac-machine/probe.cjs
  node packages/mac-machine/probe.test.cjs
  bash packages/mac-machine/test.sh
  bash packages/mac-machine/steps.test.sh
