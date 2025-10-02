#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Optional: disable HTTPS certificate verification (last resort)
# Usage: LOCALIZE_IMAGES_INSECURE=1 ./scripts/localize_images.sh
if [[ "${LOCALIZE_IMAGES_INSECURE:-0}" == "1" ]]; then
  export PYTHONHTTPSVERIFY=0
  echo "[warn] SSL verification disabled (LOCALIZE_IMAGES_INSECURE=1). Use only in trusted environments."
fi

# Prefer a proper fix: ensure Python has a CA bundle (via certifi) and export it for urllib/ssl/OpenSSL
if [[ "${LOCALIZE_IMAGES_INSECURE:-0}" != "1" ]]; then
  if ! python3 - <<'PY' >/dev/null 2>&1
import certifi
print(certifi.where())
PY
  then
    echo "[info] Installing certifi (user scope) to provide CA bundle..."
    python3 -m pip install --user --quiet certifi
  fi
  export SSL_CERT_FILE="$(python3 - <<'PY'
import certifi, sys
sys.stdout.write(certifi.where())
PY
)"
  echo "[info] Using CA bundle: ${SSL_CERT_FILE}"
fi

python3 "${ROOT_DIR}/tools/localize_images.py" \
  --base "${ROOT_DIR}/wiremock" \
  --placeholder "${ROOT_DIR}/tools/placeholder.png"
