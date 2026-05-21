#!/usr/bin/env python3
from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]


def run(command: list[str]) -> int:
    print(f"==> {' '.join(command)}")
    return subprocess.run(command, cwd=ROOT).returncode


def main() -> int:
    results = [
        ("workflow_check", run([sys.executable, "scripts/workflow_check.py"])),
        ("project_checks", run(["./scripts/checks.sh"])),
    ]

    status = "OK" if all(code == 0 for _, code in results) else "FAIL"
    log_dir = ROOT / ".agents"
    log_dir.mkdir(exist_ok=True)
    with (log_dir / "workflow_guard_runs.md").open("a", encoding="utf-8") as file:
        file.write(f"## {datetime.now(timezone.utc).isoformat()} - {status}\n\n")
        file.write("- command: python3 scripts/agent_finish.py\n")
        for name, code in results:
            file.write(f"- {name}: {code}\n")
        file.write("\n")

    if status != "OK":
        print("Agent Finish: FAIL")
        return 1

    print("Agent Finish: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
