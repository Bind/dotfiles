# Set up a Mac for Sutro

Run one step at a time. Each script says what it did and what to run next.
Steps 1–7 run on the **new Mac**. `send-keys.sh` runs on the **existing Mac**.
Do not use `sudo` for these scripts.

The package must be in both dotfiles checkouts. Clone or update the public repo on
both Macs. It contains setup code, not credentials.

On the new Mac, install Apple's command-line tools, finish that installer, then clone:

```bash
xcode-select --install
```

```bash
git clone https://github.com/Bind/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

| Step | Command | What the human does |
| --- | --- | --- |
| 1 | `packages/mac-machine/01-tools.sh` | Install Homebrew if prompted; rerun the step. |
| 2 | `packages/mac-machine/02-sign-in.sh` | Sign into Tailscale and GitHub. If Tailscale sign-in is pending, finish it and rerun. |
| 3 | `packages/mac-machine/03-sutro.sh` | Let Sutro install its pinned runtimes and dependencies. |
| 4 | `packages/mac-machine/04-recipient.sh` | Copy the printed public recipient to the existing Mac. |
| Send | Run the printed `send-keys.sh` command on the existing Mac. | Substitute the new Mac's Tailscale name; compare the recipient on both screens. |
| 5 | `packages/mac-machine/05-import-keys.sh` | Import the encrypted download and verify environment decryption. |
| 6 | `packages/mac-machine/06-executor.sh` | Install Executor Desktop if prompted, rerun, and finish Cloudflare browser sign-in. |
| 7 | `packages/mac-machine/07-check.sh` | Confirm an authenticated hosted Executor API read succeeds. |

Stop when a script fails. It prints the required action; do that and rerun the same
step. A successful step prints `Ready:` followed by `Next:`. These scripts do not
automatically advance to another step or replace existing credentials.

## Sending the keys

Step 4 prints the new Mac's `age1...` recipient. On the existing Mac, use that
recipient, the new Mac's actual Tailscale hostname, and the source key-file path:

```bash
packages/mac-machine/send-keys.sh age1RECIPIENT NEW_MAC_TAILSCALE_NAME ~/workspace/sutro/.env.keys
```

Replace `age1RECIPIENT` and `NEW_MAC_TAILSCALE_NAME`; they are placeholders.
Install the sender tools on the existing Mac with `brew install age jq` if needed.
The source file must be named `.env.keys` and have mode 600; use `chmod 600` on it
if prompted. The sender verifies that the destination is online, untagged and owned
by your Tailscale account, then asks you to type the complete age recipient to
authorize the transfer. Nothing is sent before confirmation.

Both Macs must be signed into the same Tailscale account and be untagged. Enable
Send Files in the tailnet's admin settings and Tailscale Sharing in macOS System
Settings → General → Login Items & Extensions → Sharing. Received files arrive in
Downloads. The sender reports transfer failures; it never reports success after
Tailscale fails.

The private age identity stays in `~/.config/binder-machine/age.identity` with mode
600 in a mode-700 directory. Only its public recipient is copied. The sender encrypts
the selected `.env.keys` before Taildrop transfers it. Temporary encrypted files are
removed on exit. The importer publishes a mode-600 `.env.keys` atomically and rejects
tracked/unignored destinations, symlinks, wrong recipients and corrupt ciphertext.
It accepts only dotenvx private-key assignments and never executes the key file as
shell code. Credential-bearing HTTP requests use the fixed `https://exc.binder.sh`
origin and do not follow redirects. There is no arbitrary-command runner with the
decrypted environment.

Step 5 can be rerun: an existing `.env.keys` is checked without being replaced. If it
is incorrect, inspect it before removing or rotating it; the scripts do not erase it.
Delete the encrypted download after successful import.

## Paths and filenames

The default checkout is `~/workspace/sutro`. For a different path, pass it to steps
3 and 4, and use the commands printed afterwards. For a renamed Taildrop download:

```bash
packages/mac-machine/05-import-keys.sh ~/Downloads/sutro-keys-1.age ~/workspace/sutro
```

Each script supports `--help`. Commands work from any directory when invoked by
absolute path; no shell alias or generated `.zshrc` is required.

## Executor handoff

Step 6 installs/opens the local app and opens `https://exc.binder.sh` for browser
sign-in. Step 7 verifies the hosted `/api/integrations` endpoint using credentials
from the encrypted Sutro environment. Browser login does not supply CLI credentials.

Use a complete `EXECUTOR_CF_ACCESS_CLIENT_ID` / `EXECUTOR_CF_ACCESS_CLIENT_SECRET`
pair for a dedicated machine token. The existing `HEX_PROVISIONER_ACCESS_CLIENT_ID`
/ `HEX_PROVISIONER_ACCESS_CLIENT_SECRET` pair is also supported. Missing or rejected
credentials stop the check with guidance. Never paste secret values into these commands.

After step 7, finish the local-app connection using the configuration agreed in the
separate Executor chat. Verify it there with a read-only DEC model-info call. These
numbered scripts do not modify server profiles or MCP integrations. Their readiness
check does not depend on the CLI's incompatible `/api/health` probe.

## Scope

This installs development tools, clones Sutro, transfers dotenvx keys, opens Executor,
and verifies remote API access. It does not migrate databases, deploy services, copy
browser/SSH sessions, or install a boot-time daemon. The original dotfiles `install.sh`
is an optional separate step that changes shell/editor configuration.

Copying the full `.env.keys` grants all access decryptable by that keyring, including
CI keys if present. Revoke machine tokens and rotate affected keys when retiring a Mac.
Removing a Tailscale device does not invalidate keys already copied to it.

## Maintainer checks

```bash
just check
```

Checks use fake credentials, isolated temporary files and stubbed external commands.
They do not transfer real keys, install packages, open apps or change the deployment.

References: [Homebrew](https://brew.sh/), [Bun installation](https://bun.com/docs/installation),
[Taildrop](https://tailscale.com/docs/features/taildrop), [Executor downloads](https://executor.sh/#run-it).
