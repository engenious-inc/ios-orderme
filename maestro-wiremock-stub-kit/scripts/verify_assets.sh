#!/usr/bin/env bash
# Verify that JSON bodies reference /assets/* and that corresponding files & mappings exist.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

FILES_DIR="${ROOT_DIR}/wiremock/__files"
MAPS_DIR="${ROOT_DIR}/wiremock/mappings"
ASSET_DIR="${FILES_DIR}/assets"

missing=0
total=0

grep -Rho '"imagePath"\s*:\s*"/assets/[^"]\+"' "${FILES_DIR}"/*.json | sed -E 's/.*"\/assets\/([^"]+)".*/\1/' | while read -r asset; do
  total=$((total+1))
  if [[ ! -f "${ASSET_DIR}/${asset}" ]]; then
    echo "[miss] file: ${ASSET_DIR}/${asset}"
    missing=$((missing+1))
  fi
  h="${asset%.*}"
  if [[ ! -f "${MAPS_DIR}/img-${h}.json" ]]; then
    echo "[miss] mapping: ${MAPS_DIR}/img-${h}.json"
    missing=$((missing+1))
  fi
done

echo "Checked ${total} assets. Missing entries: ${missing}."
if [[ ${missing} -gt 0 ]]; then
  exit 1
fi
