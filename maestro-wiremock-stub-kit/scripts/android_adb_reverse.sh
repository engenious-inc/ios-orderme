#!/usr/bin/env bash
set -euo pipefail
PORT="${1:-8080}"
adb devices | awk 'NR>1 && $2=="device"{print $1}' | while read -r dev; do
  echo "[+] adb -s $dev reverse tcp:${PORT} tcp:${PORT}"
  adb -s "$dev" reverse "tcp:${PORT}" "tcp:${PORT}" || true
done
echo "Done."
