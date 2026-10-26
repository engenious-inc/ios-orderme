# Review checklist

Use the Selectors section while researching (step 3) and the whole list when reviewing changed files (step 8). For each item, note pass/fail in one line. Fix failures inside the approved scope; report the rest. These checks add detail to the rules in `CLAUDE.md` and don't replace them.

## Selectors

- **`id:` needs wiring evidence.** In this app, identifiers are attached in `orderMe/Main.storyboard` (`<accessibility key="accessibilityConfiguration" identifier="…"/>`) or in Swift (`….accessibilityIdentifier = …`). `orderMe/Model/AccessibilityIdentifiers.swift` declares constants, and some of them are never assigned to a view. Grep for where the constant is *used*, not where it is declared.
- **Data-driven ids.** Some views copy their label text or model data into the identifier (search for `accessibilityIdentifier = ` with a non-literal right-hand side, e.g. `PlaceCell.swift`, `DishesController.swift`, `PlaceMainMenuController.swift`). An `id:` built from data is no more stable than text and is harder to read. Prefer the text selector and say why.
- **Text is a full-string, case-insensitive regex.** Copy strings verbatim — some labels contain leading spaces. Escape regex metacharacters (`? . * + ( ) [ ] |`), or use `.*` only on purpose. Take text from source strings, `*.lproj/*.strings`, or `inspect_screen` output — never from a screenshot.
- **Locale.** The app ships `en`, `es`, and `fr` (`orderMe/*.lproj`). A text selector ties a flow to one language. For flows that must work in any locale, prefer a verified `id`. Otherwise, parameterize the label via `env`, as `flows/auth/login-screen-fr.yaml` does.
- **Avoid `point:` and `index:`** unless nothing else identifies the element; justify it in the proposal.

## Assertions

- At least one business-outcome assertion runs **unconditionally**. If every assertion sits inside `runFlow: when:`, the flow can pass without checking anything.
- **Negative assertions:** `assertNotVisible` passes immediately when the element isn't present *yet*. Put it after a positive assertion that proves the app has settled into the expected state, such as the blocking dialog.
- The flow ends with an assertion, not a tap.
- Before interacting with a slow, network-bound screen, assert that you have arrived on it.

## Synchronization

- No fixed delays to hide timing problems. Rely on the built-in waiting in `tapOn`/`assertVisible`. For slow backend-driven content, use `extendedWaitUntil` with an explicit `timeout`.
- Use `runFlow: when:` only for genuinely nondeterministic UI, such as system permission prompts (the location dialog) or one-time interstitials. Never use it to make a required step optional.
- When the target's list position depends on backend data, prefer `scrollUntilVisible` over a bare `scroll` followed by `tapOn`.
- **App state:** top-level flows start from `helpers/_bootstrap.yaml` (`clearState`). Some subflows call `launchApp` themselves and reset state mid-flow. Check a subflow's first steps before composing it.

## Duplication and reuse

- No step sequence copied from an existing subflow.
- No near-duplicate of an existing flow; express variants through `env`.
- A new subflow only when it is reusable beyond this scenario, and it declares `env` defaults so it runs standalone.
- Changes to shared subflows keep existing callers' behavior (unchanged defaults), and the report lists those callers.

## Maintainability

- Placement, naming, `appId`, `onFlowStart`, and tags follow CLAUDE.md and the neighboring files.
- Every `runFlow`/`runScript` path resolves (`scripts/check_flow_paths.py`).
- No credentials, phone numbers, or other personal data added inline; pass them via `env` at run time (`-e KEY=value`). Report inline secrets that already exist instead of copying the pattern.
- Data assumptions (restaurant, dish, table) live in `env` defaults, not scattered literals.
