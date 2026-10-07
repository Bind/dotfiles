#!/usr/bin/env bash
# Clone Sutro and run its own dependency bootstrap.
# shellcheck source=common.sh
source "$(dirname "$0")/common.sh"
step_usage='03-sutro.sh [sutro-checkout]'
step_description='Step 3/7 — NEW Mac: clone Sutro and install its dependencies.'
start_step "${1:-}"
mac_only
need gh
need mise
checkout="${1:-$HOME/workspace/sutro}"
if [[ ! -e "$checkout" ]]; then
  mkdir -p "$(dirname "$checkout")"
  gh repo clone Bind/Sutro "$checkout"
fi
[[ -d "$checkout/.git" && -f "$checkout/scripts/bootstrap-dependencies.sh" ]] || fail 'This path is not a Sutro checkout. Next: rerun with the correct checkout path.'
remote="$(git -C "$checkout" remote get-url origin)"
case "$remote" in
  https://github.com/Bind/Sutro.git|https://github.com/Bind/Sutro|git@github.com:Bind/Sutro.git|https://github.com/bind/sutro.git) ;;
  *) fail 'This checkout has an unexpected origin. Next: inspect it before running its bootstrap.' ;;
esac
(cd "$checkout"; mise trust; bash scripts/bootstrap-dependencies.sh)
echo "Ready: Sutro dependencies installed in $checkout."
next_step 04-recipient.sh "$checkout"
