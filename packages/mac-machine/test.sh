#!/usr/bin/env bash
# Exercise encrypted transfers using fake credentials only.
set -euo pipefail
umask 077
machine="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/machine"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT
export HOME="$test_dir/home"
mkdir -p "$HOME" "$test_dir/bin" "$test_dir/repo"
export PATH="$test_dir/bin:$PATH"
export TEST_SENT="$test_dir/sent.age"
cat > "$test_dir/bin/tailscale" <<'STUB'
#!/usr/bin/env bash
set -euo pipefail
case "$1" in
  status)
    printf '{"BackendState":"Running","Self":{"UserID":1},"Peer":{"peer":{"UserID":%s,"Online":%s,"Tags":%s,"HostName":"new-mac","DNSName":"new-mac.test.ts.net.","TailscaleIPs":["100.64.0.2"]}}}\n' "${TEST_OWNER:-1}" "${TEST_ONLINE:-true}" "${TEST_TAGS:-[]}"
    ;;
  file) [[ "$2" == cp && "$4" == 100.64.0.2: ]]; cp "$3" "$TEST_SENT" ;;
  *) exit 1 ;;
esac
STUB
chmod +x "$test_dir/bin/tailscale"
git -C "$test_dir/repo" init -q
git -C "$test_dir/repo" remote add origin https://github.com/Bind/Sutro.git
printf '.env.keys\n.machine-import.*/\n' > "$test_dir/repo/.gitignore"
printf 'DOTENV_PRIVATE_KEY=%064d\n' 0 > "$test_dir/.env.keys"
recipient="$("$machine" recipient)"
[[ "$recipient" == "$("$machine" recipient)" ]]
printf '%s\n' "$recipient" | "$machine" send "$test_dir/.env.keys" "$recipient" new-mac
# Refuse wrong owners, tagged/offline peers and unconfirmed recipients before sending.
mv "$TEST_SENT" "$test_dir/good.age"
for rejection in owner tags offline confirmation; do
  export TEST_OWNER=1 TEST_TAGS='[]' TEST_ONLINE=true
  answer="$recipient"
  case "$rejection" in
    owner) export TEST_OWNER=2 ;;
    tags) export TEST_TAGS='["tag:server"]' ;;
    offline) export TEST_ONLINE=false ;;
    confirmation) answer=no ;;
  esac
  if printf '%s\n' "$answer" | "$machine" send "$test_dir/.env.keys" "$recipient" new-mac > "$test_dir/rejected" 2>&1; then exit 1; fi
  [[ ! -e "$TEST_SENT" ]]
done
mv "$test_dir/good.age" "$TEST_SENT"
export TEST_OWNER=1 TEST_TAGS='[]' TEST_ONLINE=true
if cmp -s "$test_dir/.env.keys" "$TEST_SENT"; then exit 1; fi
"$machine" receive "$TEST_SENT" "$test_dir/repo"
cmp "$test_dir/.env.keys" "$test_dir/repo/.env.keys"
[[ "$(stat -f '%Lp' "$test_dir/repo/.env.keys")" == 600 ]]
if "$machine" receive "$TEST_SENT" "$test_dir/repo"; then exit 1; fi
rm "$test_dir/repo/.env.keys"
printf 'bad ciphertext\n' > "$test_dir/bad.age"
if "$machine" receive "$test_dir/bad.age" "$test_dir/repo"; then exit 1; fi
[[ ! -e "$test_dir/repo/.env.keys" ]]
other="$(age-keygen -o "$test_dir/other.identity" 2>&1 | sed -n 's/Public key: //p')"
age -r "$other" -o "$test_dir/wrong.age" "$test_dir/.env.keys"
if "$machine" receive "$test_dir/wrong.age" "$test_dir/repo"; then exit 1; fi
[[ ! -e "$test_dir/repo/.env.keys" ]]
ln -s "$test_dir/.env.keys" "$test_dir/repo/.env.keys"
if "$machine" receive "$TEST_SENT" "$test_dir/repo"; then exit 1; fi
rm "$test_dir/repo/.env.keys"
printf '' > "$test_dir/repo/.gitignore"
if "$machine" receive "$TEST_SENT" "$test_dir/repo"; then exit 1; fi
printf '.env.keys\n' > "$test_dir/repo/.gitignore"
cp "$test_dir/.env.keys" "$test_dir/repo/.env.keys"
git -C "$test_dir/repo" add -f .env.keys
rm "$test_dir/repo/.env.keys"
if "$machine" receive "$TEST_SENT" "$test_dir/repo"; then exit 1; fi
[[ -z "$(find "$test_dir/repo" -name '.machine-import.*' -print)" ]]
printf 'ARBITRARY_SECRET=value\n' > "$test_dir/invalid.keys"
age -r "$recipient" -o "$test_dir/invalid.age" "$test_dir/invalid.keys"
git -C "$test_dir/repo" rm --cached -q .env.keys
if "$machine" receive "$test_dir/invalid.age" "$test_dir/repo" > "$test_dir/invalid-output" 2>&1; then exit 1; fi
[[ ! -e "$test_dir/repo/.env.keys" ]]
if rg -q ARBITRARY_SECRET "$test_dir/invalid-output"; then exit 1; fi
echo 'PASS: encrypted transfer, recipient confirmation, peer ownership/tags/online checks, key format, import permissions and overwrite protections'
