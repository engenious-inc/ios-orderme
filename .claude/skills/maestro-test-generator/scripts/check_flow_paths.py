#!/usr/bin/env python3
"""Report runFlow/runScript file references in Maestro YAML that do not resolve.

Usage: check_flow_paths.py <file-or-directory> [...]

Paths are resolved relative to the referencing file, as Maestro does.
Read-only, standard library only. Exits 1 if any reference is broken.
"""
import os
import re
import sys

REFERENCE = re.compile(
    r"""^\s*(?:-\s*)?(?:runFlow|runScript|file)\s*:\s*["']?([^\s"'#]+\.(?:ya?ml|js))["']?\s*(?:#.*)?$"""
)


def yaml_files(paths):
    for path in paths:
        if os.path.isdir(path):
            for root, dirs, names in os.walk(path):
                dirs.sort()
                for name in sorted(names):
                    if name.endswith((".yaml", ".yml")):
                        yield os.path.join(root, name)
        else:
            yield path


def main(argv):
    if not argv:
        print(__doc__.strip())
        return 2
    checked = broken = 0
    for flow in yaml_files(argv):
        base = os.path.dirname(flow)
        with open(flow, encoding="utf-8") as handle:
            for lineno, line in enumerate(handle, 1):
                match = REFERENCE.match(line)
                if not match:
                    continue
                ref = match.group(1)
                checked += 1
                if "${" in ref:
                    print(f"SKIP   {flow}:{lineno} -> {ref} (interpolated)")
                elif not os.path.exists(os.path.normpath(os.path.join(base, ref))):
                    broken += 1
                    print(f"BROKEN {flow}:{lineno} -> {ref}")
    print(f"{checked} reference(s) checked, {broken} broken")
    return 1 if broken else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
