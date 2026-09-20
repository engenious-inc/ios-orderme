# OrderMe — Maestro QA Automation

OrderMe is a restaurant-ordering iOS app (bundle id `com.assesment.orderme`) used as a teaching/reference project for QA automation. Guests can browse restaurants, reserve a table, and order dishes; some actions require Facebook login.

## Maestro root

This workflow targets `Maestro/ios/`. Layout:

- `flows/auth/` — authentication and login behavior (login screen state, guest/"login later", locale, error-state flows).
- `flows/restaurants/` — restaurant discovery, menu, cart, and ordering scenarios (browsing restaurants, table selection, dish/cart handling, placing an order). New ordering scenarios belong here, not in `flows/features/`.
- `flows/reservations/` — reservation-related scenarios (booking a table).
- `flows/features/` — cross-cutting or other behavior that doesn't naturally belong to the folders above.
- `helpers/` — shared setup: `_bootstrap.yaml` (launchApp + clearState, run via `onFlowStart`), `_load_elements.yaml` (loads `elements/*.js` into `output.*`), `config.yaml` (`includeTags`/`excludeTags` for filtered runs).
- `elements/*.js` — named selector groups exposed as `output.<group>.<name>` (login, restaurants, reservation). Using these is optional — many flows use inline string/`id` literals instead, and both patterns are established in the repo.
- `subflows/screens/` — reusable, parameterized screen-level flows (e.g. login-later, facebook-login, detect-table, add-dish-to-bucket, table-reservation).
- `subflows/components/` — reserved for reusable component-level subflows (currently empty).

Note: `flows/restaurants/` currently only has a placeholder (`.gitkeep`), and some existing ordering/table-selection flows still live under `flows/features/` from before this taxonomy was written down (e.g. the end-to-end order flow). Don't move them as drive-by cleanup — but any new ordering scenario should go under `flows/restaurants/`.

## Reuse rule

Before writing new steps, check `subflows/screens/` and existing `flows/**` for something that already covers the interaction, and prefer `runFlow` over duplicating steps. Add a new subflow only when the interaction is genuinely reusable beyond a single scenario — a one-off sequence stays inline in its flow.

## Conventions

- Every flow declares `appId: com.assesment.orderme`; non-subflow, top-level flows also declare `onFlowStart: - runFlow: ../../helpers/_bootstrap.yaml` (path depth varies with folder nesting).
- Parameterize with `env:` using the `${var || "default"}` pattern so a flow/subflow works standalone and can still be overridden by a caller via `runFlow: {file, env}`.
- Existing tags include `dev`, `guest`, `reservations`, `subflow`, `localization`, `french`. Reuse an existing tag when it fits; only add a new one when none does.

## Selectors

- Prefer a stable accessibility identifier (`id:`) when it's verified to actually be attached to the element — e.g. an `accessibilityConfiguration identifier="..."` in the storyboard, or an `accessibilityIdentifier = ...` assignment in source, for that specific control.
- Visible text is an acceptable, commonly used selector here when no reliable identifier exists.
- Never trust an identifier just because a similarly-named constant exists somewhere in source — confirm it's wired to the element you intend to interact with.

## Assertions

- Assert the business outcome (an order accepted/rejected, a state that reflects a real decision), not just that a screen transition happened.
- When a scenario requires something to be *prevented*, explicitly consider a negative assertion — one that proves the forbidden outcome did not occur, not only that a blocking dialog appeared. Include it when the forbidden outcome has a reliable, observable signal to assert against (e.g. a success state, a record that would otherwise get created); if no such signal exists, state that limitation rather than inventing one.

## Runtime notes

- Flows run against a built `OrderME.app` in the iOS Simulator via `maestro test`.
- Simulator locale affects text selectors — verify the target simulator's language before relying on English (or any specific-language) text.
- Known limitation: several flows depend on shared/live backend data (restaurant list, menu contents, reservation availability) rather than a fixed fixture, so results can vary between runs. `maestro-stub-recorder/` exists in the repo but is not currently wired into any flow.

## Do not

Do not modify production app code (`orderMe/**`) to make a test pass, unless explicitly asked to change the app.
