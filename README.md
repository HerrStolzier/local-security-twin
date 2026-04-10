# Local Security Twin

Local-first macOS security companion for normal users, combining privacy, hardening, and controlled validation.

## Why this exists

Most security tools are either too shallow to be useful or so technical that normal users bounce off immediately. This project explores a calmer middle ground: a Mac app that explains what matters, checks the local machine safely, and helps people improve their setup without fear-based UX.

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

## Planned Experience

1. The app scans a limited, well-defined set of local signals.
2. It translates technical findings into normal language.
3. It groups issues by impact and effort.
4. It offers guided checks, validation steps, or safe next actions.
5. The user can track what changed over time.

## Planned Focus Areas

- privacy posture
- macOS hardening basics
- permissions and exposure checks
- guided validation tasks
- simple history of reviewed or changed items

## Planned Stack

- SwiftUI for the main app
- AppKit interop for system-heavy workflows where needed
- local system inspection only
- optional local rule engine for scoring and explanations

## Status

This repo is currently a product-direction repo.

The next step is not “add everything.” The next step is defining the smallest useful first version that already feels trustworthy and understandable.

## First Milestones

- [ ] define the first safe audit scope
- [ ] design the explanation style for findings
- [ ] decide which system checks belong in v1
- [ ] create the first guided validation flows
- [ ] build the first calm macOS dashboard

## License

MIT
