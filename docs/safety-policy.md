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

## Adversarial Review

Adversarial thinking is allowed as a design and review method.
Every larger feature must include a defensive adversarial review before implementation.

Its purpose is:

- understand realistic attacker paths
- decide which defensive signals are useful
- improve explanations and prioritization
- document honest limits

This project may use attacker thinking for defense, threat modeling, and abuse prevention.
It must not turn that thinking into exploit development, stealthy persistence, unauthorized access, or offensive automation against real systems.

It must not become:

- exploit automation
- destructive validation
- stealthy probing
- testing against third-party systems
- instructions that help a user attack someone else

Every adversarial review should end in one of these safe outputs:

- a read-only sensor idea
- a user-facing checklist
- a safer guided action
- a documented limitation
- a decision to not build the capability yet

The review asks:

- how an attacker could misuse the feature
- whether local files, caches, feeds, prompts, or policies could be manipulated
- which permissions would create new risk
- what the user must explicitly confirm
- what the feature must never do silently

## Best-Practice Monitoring

Checks for 2FA, password managers, VPN, antivirus/security tools, firewall, FileVault, drivers, System Extensions, and Network Extensions must be honest about their evidence.

The app must distinguish:

- automatically observed state
- user-confirmed state
- inferred state
- not currently checkable

The app must not ask for account passwords, 2FA backup codes, VPN credentials, or security-product secrets.
It must not change firewall, FileVault, VPN, extension, or security-tool settings without explicit, separate user confirmation.

Allowed:

- local read-only checks
- guided questions when the app cannot verify something directly
- explanations of tradeoffs, such as when a VPN helps and when it does not

Not allowed:

- claiming a practice is enabled when the app cannot verify it
- treating tool presence as proof of safety
- requesting stronger permissions without a concrete user benefit
