#!/usr/bin/env bash
# One-command workflow for recording/playback with per-test WireMock folders + optional image localization.
# Compatible with the project layout under maestro-wiremock-stub-kit/.
#
# Key changes vs. original:
#  - RECORD now writes stubs into wiremock/<test-name>/{mappings,__files}
#    where <test-name> is derived from the --flow filename (without .yaml)
#  - "shared" paths wiremock/mappings and wiremock/__files become symlinks
#    to the current test's folders, so existing tools continue to work.
#  - --api and --port have sensible defaults, so you can omit them.
#
# Examples:
#   ./maestro-wiremock-stub-kit/scripts/stub_workflow.sh record \
#     --flow Maestro/flows/burger-reservation-login.yaml
#
#   ./maestro-wiremock-stub-kit/scripts/stub_workflow.sh playback \
#     --flow Maestro/flows/burger-reservation-login.yaml
#
#   ./maestro-wiremock-stub-kit/scripts/stub_workflow.sh clean
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE="${ROOT_DIR}/compose.yaml"

DEFAULT_API="http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000"
DEFAULT_PORT="8080"

usage() {
  cat <<USAGE
Usage:
  $0 record   --flow <path/to/flow.yaml> [--api URL] [--port PORT] [--insecure]
  $0 playback --flow <path/to/flow.yaml> [--port PORT]
  $0 clean

Defaults:
  --api  ${DEFAULT_API}
  --port ${DEFAULT_PORT}
USAGE
}

die() { echo "[error] $*" >&2; exit 2; }

sanitize_name() {
  # make a filesystem-safe name
  local s="$1"
  s="$(basename "$s")"
  s="${s%.yaml}"
  s="${s%.yml}"
  s="$(echo "$s" | tr '[:upper:]' '[:lower:]')"
  # replace any non [a-z0-9._-] with '-'
  s="$(echo "$s" | sed -E 's/[^a-z0-9._-]+/-/g' | sed -E 's/^-+|-+$//g' )"
  echo "$s"
}

ensure_per_test_layout() {
  # Ensures wiremock/<test>/{mappings,__files/assets} exist and
  # points wiremock/mappings and wiremock/__files to them via symlinks.
  local test_name="$1"
  local base="${ROOT_DIR}/wiremock/${test_name}"
  local maps="${base}/mappings"
  local files="${base}/__files"
  local assets="${files}/assets"

  mkdir -p "${maps}" "${assets}"

  # Repoint shared dirs via symlinks so existing scripts keep working.
  for d in mappings __files; do
    local shared="${ROOT_DIR}/wiremock/${d}"
    local target="${base}/${d}"

    if [[ -L "${shared}" ]]; then
      rm -f "${shared}"
    elif [[ -d "${shared}" ]]; then
      # If it's a real dir, keep safety: move to timestamped backup if non-empty
      if [[ -n "$(ls -A "${shared}" 2>/dev/null || true)" ]]; then
        local ts
        ts="$(date +%Y%m%d-%H%M%S)"
        local backup="${ROOT_DIR}/wiremock/_backup-${ts}-${d}"
        echo "[info] Moving existing ${shared} to ${backup}"
        mv "${shared}" "${backup}"
      else
        rmdir "${shared}" || true
      fi
    fi

    ln -s "${target}" "${shared}"
  done

  echo "${base}"
}

wait_wiremock_ready() {
  # Wait until WireMock admin endpoint is reachable
  local base="${1:-http://127.0.0.1:8080}"
  local retries=60
  local i=0
  until curl -sS -m 1 "${base}/__admin/mappings" >/dev/null 2>&1; do
    i=$((i+1))
    if [[ $i -ge $retries ]]; then
      echo "[warn] WireMock not ready after ${retries}s; continuing anyway."
      return 0
    fi
    sleep 1
  done
}

# ---- parse CLI ----
CMD="${1:-}"
[[ -n "${CMD}" ]] || { usage; exit 2; }
shift || true

FLOW=""
API="${DEFAULT_API}"
PORT="${DEFAULT_PORT}"
INSECURE="0"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --flow) FLOW="${2:?}"; shift 2;;
    --api) API="${2:?}"; shift 2;;
    --port) PORT="${2:?}"; shift 2;;
    --insecure) INSECURE="1"; shift;;
    *) echo "[error] Unknown arg: $1"; usage; exit 2;;
  esac
done

case "${CMD}" in
  record)
    [[ -n "${FLOW}" ]] || die "--flow is required for 'record'"

    TEST_NAME="$(sanitize_name "${FLOW}")"
    TEST_ROOT="$(ensure_per_test_layout "${TEST_NAME}")"
    echo "[record] Test name: ${TEST_NAME}"
    echo "[record] Per-test dir: ${TEST_ROOT}"

    # upstream for WireMock recorder
    export REAL_API_BASE="${API}"

    echo "[record] Starting WireMock recorder (upstream: ${REAL_API_BASE})..."
    docker compose -f "${COMPOSE}" up -d wiremock-record
    wait_wiremock_ready "http://127.0.0.1:${PORT}"

    # Maestro expects BASE_URL to point to WireMock
    export WIREMOCK_BASE="http://127.0.0.1:${PORT}"
    echo "[record] WIREMOCK_BASE=${WIREMOCK_BASE}"

    # run Maestro flow
    if command -v maestro >/dev/null 2>&1; then
      echo "[record] Running Maestro flow: ${FLOW}"
      maestro test -e WIREMOCK_BASE="${WIREMOCK_BASE}" -e REAL_API_BASE="${REAL_API_BASE}" "${FLOW}"
    else
      echo "[warn] 'maestro' CLI not found in PATH – skipping test run. Ensure you run the flow manually."
    fi

    # Optional: localize remote images into __files/assets and rewrite bodies
    if [[ "${INSECURE}" == "1" ]]; then
      export LOCALIZE_IMAGES_INSECURE=1
    fi
    echo "[record] Localizing images into ${TEST_ROOT}/__files/assets ..."
    python3 "${ROOT_DIR}/tools/localize_images.py" \
      --base "${TEST_ROOT}" \
      --placeholder "${ROOT_DIR}/tools/placeholder.png" || true

    echo "[record] Switching WireMock off..."
    docker compose -f "${COMPOSE}" down || true
    echo "[record] Done. Stubs saved under: wiremock/${TEST_NAME}/"
    ;;

  playback)
    [[ -n "${FLOW}" ]] || die "--flow is required for 'playback'"

    TEST_NAME="$(sanitize_name "${FLOW}")"
    TEST_ROOT="$(ensure_per_test_layout "${TEST_NAME}")"
    echo "[playback] Using per-test dir: ${TEST_ROOT}"

    echo "[playback] Starting WireMock (read-only mappings)..."
    docker compose -f "${COMPOSE}" up -d wiremock-playback
    wait_wiremock_ready "http://127.0.0.1:${PORT}"

    export WIREMOCK_BASE="http://127.0.0.1:${PORT}"
    if command -v maestro >/dev/null 2>&1; then
      echo "[playback] Running Maestro flow: ${FLOW}"
      maestro test -e WIREMOCK_BASE="${WIREMOCK_BASE}" "${FLOW}"
    else
      echo "[warn] 'maestro' CLI not found in PATH – skipping test run. Ensure you run the flow manually."
    fi

    docker compose -f "${COMPOSE}" down || true
    echo "[playback] Done."
    ;;

  clean)
    echo "[clean] Stopping containers and cleaning tmp image mappings in shared symlinked dirs..."
    docker compose -f "${COMPOSE}" down || true
    # Only remove temporary "img-*.json" from the current shared dir if it exists
    if [[ -d "${ROOT_DIR}/wiremock/mappings" ]]; then
      find "${ROOT_DIR}/wiremock/mappings" -maxdepth 1 -name 'img-*.json' -delete || true
    fi
    # Do not remove per-test data.
    echo "[clean] Done."
    ;;

  *)
    usage
    exit 2;;
esac
