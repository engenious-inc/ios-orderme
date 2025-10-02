#!/usr/bin/env bash
# One-command workflow for recording + localizing images + switching to playback + running Maestro test.
# Usage:
#   ./scripts/stub_workflow.sh record --flow Maestro/flows/burger-reservation-login.yaml \
#       --api http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000 \
#       [--port 8080] [--insecure]
#
#   ./scripts/stub_workflow.sh playback --flow Maestro/flows/burger-reservation-login.yaml [--port 8080]
#
#   ./scripts/stub_workflow.sh clean  # Stop containers, remove tmp assets/mappings
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE="${ROOT_DIR}/compose.yaml"

FLOW=""
API=""
PORT="8080"
INSECURE=0
CMD="${1:-}"

shift || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --flow) FLOW="$2"; shift 2;;
    --api) API="$2"; shift 2;;
    --port) PORT="$2"; shift 2;;
    --insecure) INSECURE=1; shift;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

if [[ -z "${FLOW}" ]]; then
  echo "Specify --flow <path/to/maestro_flow.yaml>"
  exit 2
fi

function wait_wiremock() {
  local max_tries=60
  for i in $(seq 1 $max_tries); do
    if curl -s "http://127.0.0.1:${PORT}/__admin/mappings" >/dev/null; then
      echo "[ok] WireMock on :${PORT} is ready."
      return 0
    fi
    sleep 1
  done
  echo "[err] WireMock did not become healthy on :${PORT}"
  exit 1
}

case "${CMD}" in
  record)
    if [[ -z "${API}" ]]; then
      echo "Specify --api REAL_API_BASE (e.g. http://ec2-...:3000)"
      exit 2
    fi

    echo "[1/5] Starting wiremock-record on port ${PORT} (proxy to ${API})..."
    REAL_API_BASE="${API}" docker compose -f "${COMPOSE}" up -d wiremock-record
    wait_wiremock

    echo "[2/5] Running Maestro flow against WireMock (:${PORT})..."
    maestro test "${FLOW}"

    echo "[3/5] Localizing images to /assets (downloading to __files/assets)..."
    if [[ ${INSECURE} -eq 1 ]]; then
      LOCALIZE_IMAGES_INSECURE=1 "${SCRIPT_DIR}/localize_images.sh"
    else
      "${SCRIPT_DIR}/localize_images.sh"
    fi

    echo "[4/5] Switching to wiremock-playback..."
    docker compose -f "${COMPOSE}" stop wiremock-record || true
    docker compose -f "${COMPOSE}" up -d wiremock-playback
    wait_wiremock

    echo "[5/5] Re-running Maestro flow in playback mode..."
    maestro test "${FLOW}"

    echo ""
    echo "✅ Done. Playback stubs (including images) are ready under wiremock/."
    ;;

  playback)
    echo "[1/2] Starting wiremock-playback on port ${PORT}..."
    docker compose -f "${COMPOSE}" up -d wiremock-playback
    wait_wiremock

    echo "[2/2] Running Maestro flow in playback mode..."
    maestro test "${FLOW}"
    ;;

  clean)
    docker compose -f "${COMPOSE}" down || true
    rm -rf "${ROOT_DIR}/wiremock/__files/assets" || true
    find "${ROOT_DIR}/wiremock/mappings" -name 'img-*.json' -delete || true
    echo "Cleaned."
    ;;

  *)
    echo "Usage:"
    echo "  $0 record --flow Maestro/flows/burger-reservation-login.yaml --api http://...:3000 [--port 8080] [--insecure]"
    echo "  $0 playback --flow Maestro/flows/burger-reservation-login.yaml [--port 8080]"
    echo "  $0 clean"
    exit 2
    ;;
esac
