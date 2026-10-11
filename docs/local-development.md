# Local development

This bootstrap uses only free tools. Linux supports the CLI workflow below. [Roblox Studio officially supports Windows and macOS](https://create.roblox.com/docs/studio/setup); use one of those systems for the required runtime checks. No Wine, OS changes, paid assets, or publishing are required.

## Clone and install (Linux / macOS, Bash)

Prerequisites: Git, curl, unzip, Bash, and internet access to GitHub and Roblox's API definitions. On Ubuntu/Zorin, if these commands are missing:

```bash
sudo apt-get update
sudo apt-get install git curl unzip
```

Clone into a new directory (skip cloning if already checked out), then run all commands from the repository root:

```bash
git clone https://github.com/Pavel404-dev/StealTheHouse.git
cd StealTheHouse
```

Install the pinned official [Rokit 1.2.0 release](https://github.com/rojo-rbx/rokit/releases/tag/v1.2.0) locally. This uses Rokit's supported [`ROKIT_ROOT` override](https://github.com/rojo-rbx/rokit/blob/v1.2.0/lib/storage/home.rs); tools stay in ignored `.tools/` without editing shell startup files or needing Rust/Node.

```bash
export ROKIT_ROOT="$PWD/.tools/rokit"
export PATH="$ROKIT_ROOT/bin:$PATH"
mkdir -p "$ROKIT_ROOT/bin"

case "$(uname -s)" in
  Linux) rokit_os=linux ;;
  Darwin) rokit_os=macos ;;
  *) echo 'Use the Windows instructions below'; exit 1 ;;
esac
case "$(uname -m)" in
  x86_64) rokit_arch=x86_64 ;;
  aarch64|arm64) rokit_arch=aarch64 ;;
  *) echo 'Unsupported CPU architecture'; exit 1 ;;
esac

curl -fL "https://github.com/rojo-rbx/rokit/releases/download/v1.2.0/rokit-1.2.0-${rokit_os}-${rokit_arch}.zip" -o .tools/rokit.zip
unzip -o .tools/rokit.zip rokit -d "$ROKIT_ROOT/bin"
chmod +x "$ROKIT_ROOT/bin/rokit"
rokit install

rokit --version
rojo --version
stylua --version
selene --version
lune --version
```

At the Rokit trust prompt, review and trust the four repositories in `rokit.toml`. Expected versions: Rokit **1.2.0**, Rojo **7.7.1**, StyLua **2.6.0**, Selene **0.32.0**, Lune **0.11.0**. Keep exact versions in the manifest; do not run `rokit update` during normal setup. For unattended verification of this reviewed manifest, `rokit install --no-trust-check` avoids the interactive prompt.

In **each new terminal**, return to the checkout root and enable its tools:

```bash
export ROKIT_ROOT="$PWD/.tools/rokit"
export PATH="$ROKIT_ROOT/bin:$PATH"
```

### Windows for Studio verification

Clone the same branch/commit on a Windows machine. From PowerShell at the checkout root:

```powershell
$env:ROKIT_ROOT = "$PWD\.tools\rokit"
$env:PATH = "$env:ROKIT_ROOT\bin;$env:PATH"
New-Item -ItemType Directory -Force "$env:ROKIT_ROOT\bin" | Out-Null
Invoke-WebRequest https://github.com/rojo-rbx/rokit/releases/download/v1.2.0/rokit-1.2.0-windows-x86_64.zip -OutFile .tools\rokit.zip
Expand-Archive .tools\rokit.zip -DestinationPath "$env:ROKIT_ROOT\bin" -Force
rokit install
```

This archive is for x86_64 Windows; select the `windows-aarch64` release on ARM. Repeat the two environment assignments in new PowerShell terminals. The quality commands below work there too; use `New-Item -ItemType Directory -Force build` instead of `mkdir -p build`.

## Project layout

| Source | Roblox DataModel | Kind |
| --- | --- | --- |
| `src/server/bootstrap.server.luau` | `ServerScriptService.Server.bootstrap` | Script |
| `src/client/bootstrap.client.luau` | `StarterPlayer.StarterPlayerScripts.Client.bootstrap` | LocalScript |
| `src/shared/Bootstrap.luau` | `ReplicatedStorage.Shared.Bootstrap` | ModuleScript |

During play, StarterPlayerScripts content is copied to each player's PlayerScripts. Both bootstrap scripts require the same shared module via ReplicatedStorage. The client also prints its player name to identify each client in the multiplayer smoke test.

`default.project.json` owns a 128×128 anchored ground surface (top at Y=0) and a neutral, enabled spawn on top. There is no gameplay map. Tests and tools are outside the synced tree. Edit source files, rather than synced scripts in Studio; Rojo sync is from filesystem to Studio.

## Format, lint, and test

Run from the checkout root:

```bash
stylua src tests
stylua --check src tests
selene src tests
lune run tests/run.luau
```

StyLua explicitly uses Luau syntax. Selene uses its Roblox standard library and automatically downloads/caches API definitions; first lint and periodic cache refresh require internet access. These definitions are generated cache, not tracked source. See the [Selene Roblox guide](https://kampfkarren.github.io/selene/roblox.html) and [StyLua documentation](https://github.com/JohnnyMorganz/StyLua).

The selected runner is [Lune](https://lune-org.github.io/docs/getting-started/2-command-line-usage/), using ordinary Luau assertions without a framework or package dependencies. `tests/run.luau` requires the actual shared source module, verifies both startup messages, and checks that invalid contexts raise a useful error. Expected output: `PASS: shared bootstrap messages and invalid-context assertions`. It runs on Linux and does **not** require Studio. An uncaught assertion produces a nonzero process exit code. This checks pure shared code; it does not execute Roblox server/client scripts, replication, or physics.

To verify the runner's failure exit code on Linux/macOS without changing source:

```bash
if printf '%s\n' 'assert(false, "intentional runner failure probe")' | lune run -; then
  echo 'FAIL: runner accepted a failed assertion'
  exit 1
else
  echo 'PASS: failed assertion returned a nonzero exit code'
fi
```

## Build and serve

```bash
mkdir -p build
rojo build default.project.json -o build/StealTheHouse.rbxlx
rojo serve default.project.json
```

Build produces an ignored, generated place which Studio can open via **File → Open from File**. Serve listens on `127.0.0.1:34872`; stop it with Ctrl+C. It must run on the same machine as Studio for the localhost instructions below. On Linux, serving confirms the CLI starts; successful HTTP responses do not prove plugin synchronization or Roblox runtime behavior.

## Required Studio smoke tests (Windows / macOS)

These checks remain manual until run on the feature commit with Studio. The [Rojo installation guide](https://rojo.space/docs/v7/getting-started/installation/) covers the CLI and plugin; [Roblox testing modes](https://create.roblox.com/docs/studio/testing-modes) explains solo and multiple-client sessions. UI labels can differ between Studio versions.

### Plugin connection and source synchronization

1. Install Studio and sign in. Install the matching pinned Rojo plugin with `rojo plugin install` on the Studio machine, then restart Studio. Alternatively download `Rojo.rbxm` from [Rojo 7.7.1](https://github.com/rojo-rbx/rojo/releases/tag/v7.7.1) and place it in the folder opened by Studio's **Plugins → Plugins Folder**. Use one installation method to avoid duplicate plugins.
2. Build and open `build/StealTheHouse.rbxlx`. Start `rojo serve default.project.json` in the checkout on that machine.
3. In Studio's **Plugins → Rojo**, connect to `localhost`, port `34872`, and accept the sync preview. Confirm the Explorer paths/classes in the table above and `Workspace.Ground` / `Workspace.Spawn`.
4. With play stopped, temporarily add `-- sync smoke test` to `src/shared/Bootstrap.luau` and save. Confirm that exact comment appears in `ReplicatedStorage.Shared.Bootstrap.Source` in Studio. Remove the comment in the source file, save, and confirm its removal in Studio. Check `git diff` to ensure the temporary edit is gone.

### Play: server, client, shared, spawn

1. Open **Output**, clear prior messages, and select **Play / Test (F5)**, which inserts an avatar. Do not use **Run**, which has no player/client bootstrap.
2. Verify exactly one server startup message and one client startup message per session, with the client player name:

   ```text
   [StealTheHouse] Server bootstrap ready; shared module loaded.
   [StealTheHouse] Client bootstrap ready; shared module loaded. Player: <player name>
   ```

   Studio may separate the print arguments with spaces/tabs. Check the server/client Output labels or toggle the server/client view.
3. Walk and jump on the ground. Confirm the avatar spawns on the platform and no script errors or infinite-yield warnings appear. Stop the test.

### Start Server + at least two Players

1. With play stopped, select **Server & Clients**, set **2 clients**, then start with **Play / F7**. Older Studio versions expose this as **Test → Start Server + 2 Players**.
2. In server Output, confirm one server/shared success message. In **each** client window's Output, confirm one client/shared success message with that client's distinct player name.
3. Confirm both avatars spawn, can move on the platform, and see each other move. Check server and both clients for errors and infinite-yield warnings.
4. End the session / clean up all sessions. Record the tested commit, Studio version, date, two client names, and results in the PR; attach Output screenshots if available.

Do not mark these tests passed based on a CLI build or unit tests. Keep the PR draft and use `Refs #1` until synchronization, Play, and the two-client smoke test have actually passed. Module/config conventions (#2), CI (#3), and the full multiplayer graybox harness (#4) are follow-up work.
