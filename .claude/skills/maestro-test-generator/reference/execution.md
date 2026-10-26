# Execution and runtime inspection

## Is Maestro MCP available?

Look for the Maestro MCP server's tools in your tool list. The engineer chooses the server name, so match on the suffix: `…list_devices`, `…inspect_screen`, `…take_screenshot`, `…cheat_sheet`, `…run`.

If they are missing:
- say plainly that Maestro MCP is unavailable in this session and that nothing was executed;
- give the CLI fallback below;
- optionally tell the engineer they can register the server with `claude mcp add maestro -- maestro mcp` (provided by the Maestro CLI). Don't run that command yourself, because it changes their configuration.

## What each tool is allowed to do

| Tool | Effect | When allowed |
|---|---|---|
| `list_devices`, `inspect_screen`, `take_screenshot`, `cheat_sheet`, `open_maestro_viewer` | Read-only | Any step, on a device the engineer already has running |
| `run` (inline `yaml`, `files`, or `dir`) | Drives the device and the app | Only after Gate B |
| `run_on_cloud`, `list_cloud_devices`, `get_cloud_run_status` | Uploads the app binary to Maestro Cloud | Only if the engineer explicitly asks for cloud execution |

Using `run` with inline YAML to reach a screen for selector discovery is execution too, so ask first. `inspect_screen` on whatever screen is already showing needs no approval.

## Before asking for Gate B

State all of the following:
- the exact flow files to run and any `env` overrides;
- the target device (`list_devices`, or `xcrun simctl list devices booted`). If more than one is booted, ask which to use;
- prerequisites: the `OrderME.app` build is installed on that simulator, and the simulator language (`xcrun simctl spawn booted defaults read -g AppleLanguages`) matches the flow's text selectors;
- side effects: `clearState` wipes app data, and the flow may create reservations or orders on the shared backend or use the Facebook test account.

## Running via MCP

- Call `run` with `device_id` and `files: ["<absolute path>"]`, plus `env` if needed. Use absolute paths, because relative paths resolve against the MCP server's working directory.
- Run only the new or changed flows unless the engineer asks for more.
- **On failure:**
  1. Call `inspect_screen` and `take_screenshot` at the failure point.
  2. Classify the cause: selector, synchronization, test data or backend, environment (locale, permissions, missing build), or a genuine app defect.
  3. Report the diagnosis and the proposed fix. Applying it and running again needs the engineer's go-ahead; they may approve a fixed number of fix-and-rerun rounds at once.
- Never weaken or remove an assertion just to get a pass, and never change `orderMe/**`.

## CLI fallback

Give the engineer commands to run from the repo root. They can use `! <command>` to run them in this session so the output shows up here. Paths inside flows are resolved relative to each flow file.

```bash
# One or more flows
maestro test Maestro/ios/flows/<area>/<flow>.yaml

# With env overrides on a specific simulator
maestro test -e restaurantName=Republique --device <udid> Maestro/ios/flows/<area>/<flow>.yaml

# With a JUnit report
maestro test --format junit --output <report.xml> Maestro/ios/flows/<area>/<flow>.yaml
```

Prefer explicit file paths:
- Pointing `maestro test` at a directory runs only the top-level flow files there, unless a workspace config defines a `flows:` glob.
- `Maestro/ios/helpers/config.yaml` only takes effect when passed with `--config`, and it limits the run to `dev`-tagged flows.

Maestro writes screenshots and logs for each run under `~/.maestro/tests/<timestamp>/`. Point to them in the report when they exist.

If the engineer can't run the flow either (no simulator or no build), list the remaining manual validation steps in the report instead.
