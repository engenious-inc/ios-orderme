---
name: build-maestro-test-architecture
description: Turn a manual/business QA scenario into a reviewable Maestro test architecture plan for the OrderMe suite, before any YAML is written. Use whenever a new manual scenario needs to become a Maestro flow, or when deciding whether existing flows/subflows should be extended or reused. Produces a plan only — it does not implement or run tests.
allowed-tools: Read, Grep, Glob
---

# Build Maestro Test Architecture

You are producing an **architecture plan**, not a test. This skill has no ability to write, edit, or run files — that is intentional. The output is a document a human reviewer can approve or reject before implementation starts.

## Inputs

- The manual/business scenario as given (steps + expected result).
- The repository's stable QA conventions (`CLAUDE.md`).
- The current state of `Maestro/ios/flows/**` and `Maestro/ios/subflows/screens/**` — read the actual files, don't infer from filenames alone.

## Method

1. **Restate the scenario and its business outcome** — the thing that must actually be true or false at the end, not just "screen X appears."
2. **Search for reuse first.** Read existing flows and subflows for steps that already cover part of this scenario (login, restaurant/table selection, cart, etc.). List what you found and whether it fits as-is or needs an `env` override.
3. **Pick the destination folder** from the existing taxonomy: `flows/auth` (authentication/login), `flows/restaurants` (discovery, menu, cart, ordering), `flows/reservations` (reservations), `flows/features` (cross-cutting/other). Ordering and cart scenarios belong in `flows/restaurants`, not `flows/features` — pick the closest fit and don't invent a new folder unless nothing fits.
4. **Decide on new reusable components.** A new subflow under `subflows/screens/` (or `subflows/components/`) is justified only if the interaction is generic and likely reused beyond this one scenario. A one-off sequence stays inline in the flow.
5. **Selectors.** For every element you plan to interact with or assert on, classify its confidence:
   - **SOURCE-VERIFIED** — confirmed in source/storyboard to be assigned to the intended UI element (an `id`/accessibility identifier actually wired to that control, or stable visible text you've read directly).
   - **UNVERIFIED** — not yet confirmed; carry it into RISKS / ASSUMPTIONS as an explicit assumption, not a fact.
   This skill is read-only and can't run the app, so its selectors should normally be SOURCE-VERIFIED or UNVERIFIED. Never mark a selector RUNTIME-VERIFIED here — that confidence level can only be earned by running the app, which happens in `automate-maestro-ui-tests`.
6. **Parameters.** List the `env` variables the flow needs, with sensible defaults, following the `${var || "default"}` pattern.
7. **Tags.** Reuse an existing tag where it fits; propose a new one only if none of the existing tags describe the scenario.
8. **Assertions.** Define assertions that prove the business outcome, not just navigation. Explicitly consider a negative assertion (proving a forbidden outcome did *not* happen). Include it when the forbidden outcome has a reliable, observable signal to assert against (e.g. a success screen, a record that would otherwise be created); if there's no such signal, say so under RISKS / ASSUMPTIONS instead of inventing one.
9. **Risks and assumptions.** Call out anything environment-dependent (simulator locale, shared/live backend data, timing) or ambiguous in the scenario that the implementer needs to know about.

## Required output structure

Produce exactly this structure, filling in each section concisely:

```
SCENARIO SUMMARY
BUSINESS OUTCOME
DESTINATION
REUSE
NEW REUSABLE COMPONENTS
PARAMETERS
SELECTORS
ASSERTIONS
RISKS / ASSUMPTIONS
IMPLEMENTATION PLAN
```

`IMPLEMENTATION PLAN` should be an ordered list of concrete steps (in terms of flows/subflows and assertions), specific enough that `automate-maestro-ui-tests` can implement it without making further architecture decisions of its own.

## Boundaries

- Do not create, edit, or run any Maestro file. If you find yourself about to write YAML, stop — that belongs to the implementation skill.
- Do not guess at a selector or a piece of app behavior you haven't verified; mark it UNVERIFIED and put it in RISKS / ASSUMPTIONS instead.
- If the scenario is too ambiguous to plan (contradictory expected results, no identifiable target screen), say so plainly rather than picking an arbitrary interpretation.
