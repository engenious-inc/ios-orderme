#!/usr/bin/env python3
"""PostToolUse hook: static validation of Maestro YAML files Claude just changed.

Reads the hook payload from stdin. Acts only when the changed file is a
.yaml/.yml file under Maestro/; anything else exits 0 silently.

Required checks (static only, no device, no app launch, nothing is modified):
  1. paths  - .claude/skills/maestro-test-generator/scripts/check_flow_paths.py <file>
  2. syntax - maestro check-syntax <file>   (not applicable to workspace config files)

Result, computed from the checks:
  FAIL    - a check that completed found an error in the file.
  PARTIAL - no errors found, but a required check could not be performed.
  PASS    - every applicable check completed and found no error.

FAIL is returned as {"decision": "block", "reason": ...}; PASS and PARTIAL as
hookSpecificOutput.additionalContext. Both only add feedback next to the tool
result: the edit has already happened and this hook cannot undo it.
Standard library only. Always exits 0 unless the payload itself is unreadable.
"""
import json
import os
import re
import shutil
import subprocess
import sys

PATH_CHECKER = ".claude/skills/maestro-test-generator/scripts/check_flow_paths.py"
# Maestro workspace configs are not flows; check-syntax rejects them.
WORKSPACE_CONFIGS = {"config.yaml", "config.yml"}
# Known-good flow used to tell a syntax error apart from a broken Maestro CLI,
# because check-syntax exits 1 for both (e.g. when Java is missing).
CONTROL_FLOW = 'appId: com.assesment.orderme\n---\n- assertVisible: "control"\n'
CHECK_TIMEOUT = 45
MAX_OUTPUT = 1500
ANSI = re.compile(r"\x1b\[[0-9;]*m")

PASSED, FAILED, NOT_RUN, NOT_APPLICABLE = "passed", "failed", "not run", "not applicable"


def changed_file(payload):
    tool_input = payload.get("tool_input") or {}
    path = tool_input.get("file_path") or tool_input.get("notebook_path")
    if not isinstance(path, str) or not path:
        return None
    return os.path.join(payload.get("cwd") or os.getcwd(), path)


def maestro_binary():
    found = shutil.which("maestro")
    if found:
        return found
    fallback = os.path.expanduser("~/.maestro/bin/maestro")
    return fallback if os.access(fallback, os.X_OK) else None


def run(cmd, cwd, stdin_text=None):
    """Return (exit code or None if it could not complete, trimmed output)."""
    env = dict(os.environ, MAESTRO_CLI_NO_ANALYTICS="1",
               MAESTRO_CLI_ANALYSIS_NOTIFICATION_DISABLED="true")
    try:
        proc = subprocess.run(cmd, cwd=cwd, env=env, input=stdin_text or "",
                              capture_output=True, text=True, timeout=CHECK_TIMEOUT)
    except subprocess.TimeoutExpired:
        return None, f"timed out after {CHECK_TIMEOUT}s"
    except OSError as error:
        return None, f"could not start: {error}"
    output = ANSI.sub("", proc.stdout + proc.stderr).strip()
    if len(output) > MAX_OUTPUT:
        output = "…" + output[-MAX_OUTPUT:]
    return proc.returncode, output


def check_paths(rel, project):
    cmd = f"python3 {PATH_CHECKER} {rel}"
    if not os.path.isfile(os.path.join(project, PATH_CHECKER)):
        return NOT_RUN, cmd, f"{PATH_CHECKER} not found"
    code, out = run([sys.executable, PATH_CHECKER, rel], project)
    if code == 0:
        return PASSED, cmd, out.splitlines()[-1] if out else ""
    if code == 1:
        return FAILED, cmd, out
    return NOT_RUN, cmd, out or f"exit {code}"


def check_syntax(rel, project):
    cmd = f"maestro check-syntax {rel}"
    if os.path.basename(rel) in WORKSPACE_CONFIGS:
        return NOT_APPLICABLE, cmd, "workspace config, not a flow"
    maestro = maestro_binary()
    if not maestro:
        return NOT_RUN, cmd, "maestro CLI not found on PATH or at ~/.maestro/bin/maestro"
    code, out = run([maestro, "check-syntax", rel], project)
    if code == 0:
        return PASSED, cmd, ""
    if code is None:
        return NOT_RUN, cmd, out
    control_code, control_out = run([maestro, "check-syntax", "-"], project, CONTROL_FLOW)
    if control_code != 0:
        return NOT_RUN, cmd, ("maestro check-syntax is not working in this environment "
                              f"(a known-good control flow also failed): {control_out or out}")
    return FAILED, cmd, out


def report(rel, results):
    statuses = [status for _, status, _, _ in results]
    if FAILED in statuses:
        verdict = "FAIL"
    elif NOT_RUN in statuses:
        verdict = "PARTIAL"
    else:
        verdict = "PASS"

    lines = [f"Maestro static validation: {verdict} for {rel}"]
    for name, status, cmd, detail in results:
        line = f"- {name}: {status.upper()} ({cmd})"
        if status in (NOT_RUN, NOT_APPLICABLE):
            line += f" - {detail}"
        lines.append(line)
        if status == FAILED:
            lines.append("  " + detail.replace("\n", "\n  "))

    if verdict == "FAIL":
        lines.append("The file was already written; this hook does not undo it. Fix the errors that are "
                     "inside the approved scope; report pre-existing ones instead of fixing them "
                     "(maestro-test-generator Gate A).")
    elif verdict == "PARTIAL":
        lines.append("No errors were found, but the checks marked NOT RUN did not happen, so the file is "
                     "not statically validated. Do not report it as passing; fix the environment or run "
                     "the skipped command manually.")
    return verdict, "\n".join(lines)


def main():
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        print("maestro static check: unreadable hook payload", file=sys.stderr)
        return 1

    project = os.path.realpath(os.environ.get("CLAUDE_PROJECT_DIR") or payload.get("cwd") or os.getcwd())
    target = changed_file(payload)
    if not target:
        return 0
    target = os.path.realpath(target)
    rel = os.path.relpath(target, project)
    if (rel.startswith("..") or not rel.startswith("Maestro" + os.sep)
            or not rel.endswith((".yaml", ".yml")) or not os.path.isfile(target)):
        return 0

    results = [("paths", *check_paths(rel, project)),
               ("syntax", *check_syntax(rel, project))]
    verdict, text = report(rel, results)
    if verdict == "FAIL":
        print(json.dumps({"decision": "block", "reason": text}))
    else:
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse",
                                                 "additionalContext": text}}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
