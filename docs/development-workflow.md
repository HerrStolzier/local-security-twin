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

As the app grows, this suite should expand to cover menu bar startup, main-window navigation, and real guided actions.
