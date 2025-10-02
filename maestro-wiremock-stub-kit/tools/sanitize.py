#!/usr/bin/env python3

import re, json, os, sys, glob

MAPPINGS_DIR = sys.argv[1] if len(sys.argv) > 1 else "./wiremock/mappings"

HEADER_BLACKLIST = {"Date", "date", "Set-Cookie", "set-cookie", "Server", "server", "Expires", "expires"}
ISO_DATE_RE = re.compile(r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z")

def sanitize_mapping(path):
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # headers
    resp = data.get("response", {})
    headers = resp.get("headers", {})
    headers = {k: v for k, v in headers.items() if k not in HEADER_BLACKLIST}
    resp["headers"] = headers

    # body patterns
    body = resp.get("body", None)
    if isinstance(body, str):
        body = ISO_DATE_RE.sub("{{now iso8601}}", body)
        resp["body"] = body

    data["response"] = resp
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def main():
    for p in glob.glob(os.path.join(MAPPINGS_DIR, "*.json")):
        try:
            sanitize_mapping(p)
            print(f"[sanitized] {p}")
        except Exception as e:
            print(f"[warn] {p}: {e}")

if __name__ == "__main__":
    main()
