# Development Workflow

This project should treat every change as a calm five-step workflow:

1. Build the feature or fix.
2. Do a short refactor pass so the code stays readable.
3. Run security checks before trusting the change.
4. Run the end-to-end smoke suite before merging.
5. Update the handoff documents so another agent can resume without chat history.

## Local Commands

Run the full local workflow:

```bash
./scripts/checks.sh
```

Run only the focused checks:

```bash
./scripts/security-checks.sh
./scripts/e2e-smoke.sh
```

Build a local development `.app` bundle:

```bash
./scripts/build-app-bundle.sh
```

This creates `.build/app/LocalSecurityTwin.app` from the SwiftPM executable and signs it ad-hoc for local validation.
It is not a notarized distribution build.

Run the local app-bundle smoke check:

```bash
./scripts/app-bundle-smoke.sh
```

This rebuilds the bundle, verifies its local signature, launches it once, and stops it again.

Run the local Hardened Runtime smoke check:

```bash
./scripts/hardened-runtime-smoke.sh
```

This signs the local bundle ad-hoc with the runtime option and verifies that it still launches.

## Handoff Documents

Every finished step must leave the repo in a resumable state.

Use the docs like this:

- `AGENTS.md`: stable project rules and defaults
- `docs/session-status.md`: current checkpoint, last completed step, next concrete step
- `docs/project-learnings.md`: durable lessons that should survive many sessions

If a session ends without updating the handoff docs, the step is not considered fully done.

## What "Refactor Pass" Means Here

Refactor is not a cosmetic extra. It means:

- remove awkward naming while the change is still fresh
- keep policy, sensors, and UI boundaries clear
- prefer small focused types over large mixed files
- leave plain-language user copy easier to read than before

## Security Checks

The local security script currently blocks:

- committed secret-like values
- hard-coded network endpoints in Swift sources
- risky privileged execution APIs without an explicit review step

This is intentionally strict. The product should stay local-first and cautious by default.

## End-to-End Tests

The current E2E suite is a smoke-level integration check around the policy workflow:

- a risky request starts in "ask first" mode
- explicit approval can be remembered locally
- a new store instance reloads the remembered decision
- reset removes the remembered decision again
- a startup-diff fixture creates a temporary LaunchAgents setup, verifies that the dashboard sees a rememberable change, and verifies that remembering the current state clears the diff

## UI Test Path

For the current SwiftPM-first app, UI validation has three levels:

1. Store-/presentation-near tests in `swift test`.
2. App-bundle start validation with `./scripts/app-bundle-smoke.sh`.
3. Manual UI review against `.build/app/LocalSecurityTwin.app`.

Real macOS click automation is intentionally not the next default step yet.
It should be added after the Sandbox/Packaging decision, because SwiftPM-only bundling may not be enough for stable window and accessibility automation.

Until then, every UI-facing change should have at least one of:

- a `DashboardPresentation` or similar presentation test
- an E2E-near store flow test
- a documented manual check in `docs/session-status.md`

For the current `Als erwartet merken` flow, use this manual checklist:

1. Run `./scripts/start-startup-diff-demo.sh`.
2. The script builds `.build/app/LocalSecurityTwin.app`, stops old local instances, creates a temporary HOME, writes one demo LaunchAgent plist, writes an empty remembered startup state, and starts the app executable with that HOME.
3. Confirm the dashboard shows `com.local-security-twin.demo-new-startup-item.plist` as a visible startup change and the banner offers `Als erwartet merken`.
4. Trigger `Als erwartet merken` and confirm the confirmation text says no system settings are changed.
5. Confirm the dashboard becomes calmer afterwards: no startup diff remains and the visible item moves into the known startup hints group.

As the app grows, this suite should expand to cover menu bar startup, main-window navigation, and real guided actions.
