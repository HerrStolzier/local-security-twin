#!/usr/bin/env python3
from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "AGENTS.md",
    "WORKFLOWS.md",
    "KNOWN_ERRORS.md",
    "CHECKS.md",
    "scripts/workflow_check.py",
    "scripts/agent_finish.py",
    "scripts/checks.sh",
    "docs/session-status.md",
]

WORKFLOW_SECTIONS = [
    "Zweck",
    "Start",
    "Input",
    "Output",
    "Wichtige Dateien",
    "Abhängigkeiten",
    "Bekannte Fehlerfälle",
    "Prüfung",
    "Letzter Review",
]


def main() -> int:
    failures: list[str] = []

    for relative in REQUIRED:
        if not (ROOT / relative).exists():
            failures.append(f"missing: {relative}")

    workflows_path = ROOT / "WORKFLOWS.md"
    workflow_text = workflows_path.read_text(encoding="utf-8") if workflows_path.exists() else ""
    for heading in WORKFLOW_SECTIONS:
        if f"### {heading}" not in workflow_text:
            failures.append(f"WORKFLOWS.md missing section: {heading}")

    for relative in ["WORKFLOWS.md", "KNOWN_ERRORS.md", "CHECKS.md"]:
        path = ROOT / relative
        if path.exists() and "TODO" in path.read_text(encoding="utf-8"):
            failures.append(f"{relative} still contains TODO placeholders")

    if failures:
        print("Workflow Guard Check: FAIL")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Workflow Guard Check: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
