---
name: maestro-test-generator
description: Designs and implements maintainable Maestro UI automation flows (YAML) for this repository's OrderMe app, following the existing Maestro/ architecture of top-level flows, reusable subflows, helpers, and element maps. Use when the user asks to create, add, extend, or improve Maestro test coverage — e.g. "write a Maestro test for…", "automate this scenario with Maestro", "add a Maestro flow or subflow", "cover X in Maestro", "strengthen the assertions in this Maestro flow". Works plan-first — checks existing coverage, proposes an approach, and changes or runs nothing without explicit approval. Not for XCUITest, app code changes, or general QA strategy.
argument-hint: "[scenario to automate]"
---

# Maestro Test Generator

Design and implement the smallest maintainable Maestro flow for a requested scenario, consistent with the architecture that already exists in this repository.

Scenario from invocation (may be empty): $ARGUMENTS

## Sources of truth

1. **`CLAUDE.md`** (repo root, loaded automatically) — project rules for layout, reuse, conventions, selectors, assertions, and runtime. Its rules apply here and are not restated in this skill. If it isn't in your context, read it before step 1.
2. **Existing files under the Maestro root** that CLAUDE.md names. Treat files as the facts and CLAUDE.md as the rules. When they disagree (CLAUDE.md has drifted before), report the drift and ask rather than choosing silently.
3. **App source (`orderMe/**`)** — read-only, used to verify selectors.

Not every existing flow is a valid template: some contain `runFlow` paths that do not resolve. Before copying a pattern, run this from the repo root and only copy from files with no `BROKEN` lines:

```bash
python3 .claude/skills/maestro-test-generator/scripts/check_flow_paths.py Maestro/ios
```

## Boundaries

- **Gate A — no file changes before plan approval.** Steps 1–5 are read-only. Create, edit, move, or delete nothing until the engineer explicitly approves the proposal ("approved", "go ahead", "implement it"). A question, partial feedback, or silence is not approval. If the plan changes materially afterwards (a different file, a shared subflow now modified), confirm again.
- **Gate B — no execution before run approval.** Approving the implementation does not approve running it. Running a flow launches the app with `clearState` and may act on the shared live backend (reservations, orders, Facebook login), so ask separately. See [reference/execution.md](reference/execution.md) for what counts as execution.
- Touch only the files listed in the approved plan. No drive-by fixes of other flows; no edits to `CLAUDE.md`, `orderMe/**`, helpers, or config unless they appear in the approved plan with a reason.
- Do not introduce a new pattern (folder, helper type, element group, tag) without justifying it in the proposal.
- Never state that a flow ran or passed unless it was executed in this session and you saw the result.

## Workflow

### 1. Analyze the scenario
Restate it as preconditions (login state, permissions, locale, data), user steps, and the observable business outcome. Ask only questions whose answers change the design — which outcome proves success, guest or logged-in, which restaurant/dish/table data, positive or negative path. iOS under `Maestro/ios/` is the established target; `Maestro/android/` has a single standalone flow and no shared architecture, so ask before targeting Android. Batch questions; don't ask what the repo already answers.

### 2. Check existing coverage
Search every `flows/**` folder (legacy scenarios still live in `flows/features/`) by screen text, ids, data names, and tags. Classify:
- **Covered** → stop, point to the flow, and offer to strengthen it instead.
- **Partially covered** → prefer extending or parameterizing via `env` over a near-copy.
- **Not covered** → new flow.

Note any duplicates you encounter; report them, don't fix them.

### 3. Identify building blocks
List relevant subflows, helpers, and element groups with their `env` parameters, and find each subflow's callers (`grep -rn "<subflow-file-name>" Maestro/`). Record evidence for every selector you plan to use, following [reference/review-checklist.md](reference/review-checklist.md#selectors). If an existing shared subflow must change, list all its callers and keep defaults backward-compatible.

### 4. Propose the implementation
Present the proposal in this shape:

```
Scenario:        <one line>
Coverage:        <none | partial: <file> | covered: <file>>
Files:           <create|modify> <path> — <purpose>   (one line each; nothing else changes)
Placement:       <folder per CLAUDE.md taxonomy>, <kebab-case name>, tags <reused | new + why>
Steps:           bootstrap → <subflows with env> → <inline steps> → <assertions>
Selectors:       <selector> — <id|text> — <evidence>
Assertions:      <business outcome>; <negative assertion, or why no reliable signal exists>
Synchronization: <waits for slow/async content; conditional handling of system dialogs>
Data & env:      <backend data, locale, permissions, state assumptions>
Validation:      <static checks after writing; what would run, and on which device, if approved>
Open questions:  <if any>
```

### 5. Explain decisions and risks
Below the proposal, briefly cover: reuse vs. new subflow, inline literals vs. `elements/*.js` (match the neighbors in the target folder — both styles exist), placement, alternatives rejected, flakiness risks, and any repository inconsistencies that influenced the design.

### 6. Wait for approval (Gate A)
End the turn. Do not touch files until the engineer approves.

### 7. Implement
Write only the approved files. Mirror the neighboring files: `appId`, the `onFlowStart` bootstrap with the correct relative depth, `env` defaults, tags, and comment density (existing flows have almost none). Prefer `runFlow` to copied steps; one-off sequences stay inline.

### 8. Review
Go through [reference/review-checklist.md](reference/review-checklist.md) for every changed file. Then run the static checks; they need no device or app launch, so they don't require Gate B:

```bash
python3 .claude/skills/maestro-test-generator/scripts/check_flow_paths.py <changed files>
maestro check-syntax <changed file>   # once per file
```

Fix findings that fall within the approved scope; report the rest.

### 9. Execute (Gate B)
Follow [reference/execution.md](reference/execution.md): use Maestro MCP when available, otherwise give the engineer the exact CLI command. Don't present a manual command as if it had been run.

### 10. Report
- Files created or modified.
- Review findings and what changed because of them.
- Static checks: command → result.
- Execution: ran or not run (and why); device; per-flow result, with failing step and evidence.
- Limitations and remaining validation (not run on a device, other locales, live-data dependence, flakiness not assessed by repeated runs).
- Pre-existing issues noticed but left unchanged.
