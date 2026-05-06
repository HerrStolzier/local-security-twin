# Local Security Twin

Local-first macOS security companion for normal users, combining privacy, hardening, and controlled validation.

## Why this exists

Most security tools are either too shallow to be useful or so technical that normal users bounce off immediately.
This project explores a calmer middle ground: a Mac app that explains what matters, checks the local machine safely, and helps people improve their setup without fear-based UX.

## Core Product Idea

Local Security Twin should help a user answer simple, practical questions:

- Is my Mac configured in a sensible way?
- Where are the obvious privacy or hardening gaps?
- Which changes are safe for me to make?
- How can I validate something without turning into a terminal expert?

## Product Principles

- **Local first**: sensitive machine data should stay local
- **Explain before acting**: every recommendation needs plain-language context
- **Safe defaults**: no destructive actions hidden behind one click
- **Reversible changes**: users should understand what can be undone
- **Calm tone**: inform clearly without panic or shame

## Current Status

This repository currently contains a SwiftPM-based SwiftUI macOS skeleton with the first local security foundation in place.
It is the starting point for the product plan in:

- `../local-security-twin-plan.md`

The current implementation includes:

- a menu bar app, main window, and settings scene
- a local consent and policy model
- a normalized finding schema with evidence and recommendations
- a shared sensor contract and synchronous sensor pipeline
- a first local sensor for visible LaunchAgent and LaunchDaemon plist files
- a local startup-item baseline for later change detection
- baseline-diff findings for new or disappeared startup items

## Planned Focus Areas

- privacy posture
- macOS hardening basics
- permissions and exposure checks
- guided validation tasks
- simple history of reviewed or changed items

## Planned Stack

- SwiftUI for the main app
- AppKit interop for system-heavy workflows where needed
- local system inspection first
- optional local rule engine for scoring and explanations

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
- `docs/research-and-blindspots.md`

## Near-Term Next Steps

1. Make baseline failures visible and validate that stored baselines belong to the expected sensor.
2. Add an explicit trusted-baseline refresh flow so expected long-term changes can be re-anchored calmly.
3. Add the next calm, local-first sensor or a focused Background Task Management research spike.

## License

MIT
