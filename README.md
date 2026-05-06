# Local Security Twin

Local-first macOS security companion for normal users.

## Current Status

This repository currently contains a minimal SwiftUI macOS skeleton.
It is the starting point for the product plan in:

- `../local-security-twin-plan.md`

## Product Direction

The app should:

- inspect the local machine
- explain privacy and security concerns in plain language
- suggest safe next actions
- remember user-approved choices
- later support tightly bounded safe-mode validation

## Build

```bash
swift build
swift run LocalSecurityTwin
```

## Workflow

Run the local quality workflow before merging changes:

```bash
./scripts/checks.sh
```

That workflow intentionally includes:

- a refactor and regression pass
- local security checks
- the current end-to-end smoke suite

More detail lives in:

- `docs/development-workflow.md`
- `docs/session-status.md`
- `docs/project-learnings.md`
- `docs/macos-permissions-entitlements.md`

## Near-Term Next Steps

1. Add an explicit trusted-baseline refresh flow so expected long-term changes can be re-anchored calmly.
2. Add the next calm, local-first sensor on top of the same finding contract.
3. Expand the smoke-level E2E suite toward real UI navigation.
