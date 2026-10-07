#!/usr/bin/env bash
# Test human guidance and stop/retry behavior without installing or contacting services.
set -euo pipefail
step_dir="$(cd "$(dirname "$0")" && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/home" "$fixture/repo with spaces/node_modules/.bin"
export STEP_EVENTS="$fixture/events"
export STEP_STATE=NeedsLogin
export STEP_DECRYPT=0
cat > "$fixture/bin/open" <<'STUB'
#!/usr/bin/env bash
printf 'open\n' >> "$STEP_EVENTS"
STUB
cat > "$fixture/bin/uname" <<'STUB'
#!/usr/bin/env bash
echo Darwin
STUB
cat > "$fixture/bin/xcode-select" <<'STUB'
#!/usr/bin/env bash
exit 1
STUB
cat > "$fixture/bin/gh" <<'STUB'
#!/usr/bin/env bash
printf 'gh\n' >> "$STEP_EVENTS"
STUB
cat > "$fixture/bin/mise" <<'STUB'
#!/usr/bin/env bash
if [[ "$1" == exec ]]; then shift 2; exec "$@"; fi
exit 0
STUB
cat > "$fixture/bin/tailscale" <<'STUB'
#!/usr/bin/env bash
printf '{"BackendState":"%s"}\n' "$STEP_STATE"
STUB
repo="$fixture/repo with spaces"
cat > "$repo/node_modules/.bin/dotenvx" <<'STUB'
#!/usr/bin/env bash
exit "$STEP_DECRYPT"
STUB
chmod +x "$fixture/bin/"* "$repo/node_modules/.bin/dotenvx"
step() { local script="$1"; shift; env HOME="$fixture/home" PATH="$fixture/bin:$PATH" "$step_dir/$script" "$@"; }
for script in "$step_dir"/0*.sh "$step_dir/send-keys.sh"; do
  "$script" --help >/dev/null
done
if step 01-tools.sh > "$fixture/out" 2>&1; then exit 1; fi
rg -q 'xcode-select --install' "$fixture/out"
if step 02-sign-in.sh > "$fixture/out" 2>&1; then exit 1; fi
rg -q 'finish sign-in' "$fixture/out"
if rg -q gh "$STEP_EVENTS"; then exit 1; fi
export STEP_STATE=Running
step 02-sign-in.sh > "$fixture/out"
rg -q '03-sutro.sh' "$fixture/out"
git -C "$repo" init -q
git -C "$repo" remote add origin https://github.com/Bind/Sutro.git
printf '.env.keys\n' > "$repo/.gitignore"
mkdir -p "$repo/scripts"
printf '#!/bin/bash\nexit 0\n' > "$repo/scripts/bootstrap-dependencies.sh"
step 03-sutro.sh "$repo" > "$fixture/out"
rg -q '04-recipient.sh' "$fixture/out"
step 04-recipient.sh "$repo" > "$fixture/out"
rg -q 'EXISTING Mac' "$fixture/out"
rg -q 'send-keys.sh age1' "$fixture/out"
if step 05-import-keys.sh "$fixture/missing.age" "$repo" > "$fixture/out" 2>&1; then exit 1; fi
rg -q 'Transfer file not found' "$fixture/out"
printf 'DOTENV_PRIVATE_KEY=%064d\n' 0 > "$repo/.env.keys"
chmod 600 "$repo/.env.keys"
step 05-import-keys.sh "$fixture/missing.age" "$repo" > "$fixture/out"
rg -q '06-executor.sh' "$fixture/out"
export STEP_DECRYPT=1
if step 05-import-keys.sh "$fixture/missing.age" "$repo" > "$fixture/out" 2>&1; then exit 1; fi
rg -q 'rerun this step' "$fixture/out"
if rg -q '06-executor.sh' "$fixture/out"; then exit 1; fi
if step send-keys.sh > "$fixture/out" 2>&1; then exit 1; fi
rg -q 'Usage:' "$fixture/out"
echo 'PASS: help, prerequisites, pending login, paths with spaces, next commands, repeated import and failed decryption guidance'
