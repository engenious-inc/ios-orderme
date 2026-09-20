---
name: automate-maestro-ui-tests
description: Implement an approved Maestro test architecture plan for the OrderMe suite as working YAML, then run it with Maestro and triage the result. Use after a build-maestro-test-architecture plan has been produced and reviewed. Does not make new architecture decisions.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Automate Maestro UI Tests

You are implementing and validating an **already human-approved** architecture plan (from `build-maestro-test-architecture`). This skill writes/edits YAML and runs Maestro; it does not redesign the plan, and it should never be invoked on a plan that hasn't been explicitly approved.

## Method

1. **Read the plan and the referenced files.** Before editing anything, open every existing flow/subflow the plan says to reuse or model after, and confirm they still look the way the plan assumed.
2. **Sanity-check the plan.** If a referenced file doesn't exist, a "verified" selector isn't actually present in source, or two parts of the plan contradict each other, stop and report the discrepancy instead of improvising a fix — that's an architecture gap, not an implementation detail.
3. **Implement the top-level flow** in the destination folder the plan specified, following the repository's conventions (`CLAUDE.md`): `appId`, `onFlowStart` bootstrap, `env` defaults, tags.
4. **Reuse the declared subflows** via `runFlow`, passing `env` overrides as needed. Only create a new subflow file if the plan explicitly calls for one — inline everything else.
5. **Selectors.** A selector the plan marked SOURCE-VERIFIED becomes RUNTIME-VERIFIED once you've confirmed it against the running app (i.e. it actually worked during implementation/execution) — note that promotion in the final report. A selector the plan left UNVERIFIED must be verified — in source, then against the running app — before you rely on it; if it doesn't hold up, treat that as a plan gap under step 2, not something to paper over. If you need a selector the plan didn't cover at all, verify it yourself the same way and note it in the report.
6. **Implement the assertions exactly as planned**, including any negative assertions — do not drop or soften one just to make the run pass.
7. **Run the flow with Maestro** (`maestro test <path>`). If the simulator/runtime isn't in a usable state (nothing booted, wrong locale for the selectors in play, app not installed), fix the runtime, not the test, and note what you did.
8. **On failure, triage before changing anything:**
   - Bad YAML/selector/timing → fix the implementation and re-run.
   - Runtime/simulator issue → fix the environment and re-run.
   - The app genuinely behaves differently than the scenario/plan expected → this is a product finding, not a test bug; do not edit the app and do not edit the assertion to match it — report it.
   - Still unclear → report it as an unresolved risk rather than guessing.
9. **Never delete or weaken an assertion just to reach green.** A passing test that no longer checks the business outcome is worse than a failing one that still does.
10. **Show the diff.** After implementation, show `git status` / `git diff` for everything touched so a reviewer can see exactly what changed.

## Required final report

```
FILES CHANGED
REUSE APPLIED
ASSERTIONS IMPLEMENTED
EXECUTION RESULT
FAILURE ANALYSIS
UNRESOLVED RISKS
GIT DIFF SUMMARY
```

## Boundaries

- Do not modify production app code unless explicitly asked.
- Do not introduce new architecture decisions (new folders, new tag taxonomy, new subflow patterns) beyond what the plan specifies — send those back to `build-maestro-test-architecture` instead of deciding them here.
- Do not commit; leave changes in the working tree for review.
