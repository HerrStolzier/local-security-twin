# Safety Policy

## Default Mode

The default app behavior is:

- inspect
- explain
- recommend

The app must not silently change system settings.

## Consent

- The user should understand why an action is suggested.
- Higher-risk actions require explicit confirmation.
- Remembered approval must be visible and reversible.
- Every guided action must name what kind of action it is before the user confirms it:
  - local decision only
  - external location opening
  - guidance display
  - bounded evidence gathering
- No guided action may silently change system settings.

## Safe Mode

Future live validation must stay bounded, documented, and opt-in.
It should prove or disprove concerns without becoming a reckless attack engine.
