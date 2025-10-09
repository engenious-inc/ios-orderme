#!/usr/bin/env bash
# One-command workflow for recording/playback with per-test WireMock folders + optional image localization.
# Compatible with the project layout under maestro-wiremock-stub-kit.
#
# Key behavior:
#  - RECORD (file): writes stubs into wiremock/<test-name>/{mappings,__files}
#  - RECORD (dir): iterates all *.yaml|*.yml in the directory, recording each into its own per-test folder
#  - PLAYBACK (file): fails if the stub folder is missing or empty
#  - PLAYBACK (dir): runs only those flows that have matching stub folders; prints summary stats
#  - Shared paths wiremock/mappings and wiremock/__files are symlinks to the active test
#  - --api and --port have defaults, so they can be omitted

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE="${ROOT_DIR}/compose.yaml"

DEFAULT_API="http://ec2-18-118-12-123.us-east-2.compute.amazonaws.com:3000"
DEFAULT_PORT="8080"

usage() {
  cat <<USAGE
Usage:
  $0 record   --flow <path/to/flow.yaml|dir> [--api URL] [--port PORT] [--insecure]
  $0 playback --flow <path/to/flow.yaml|dir> [--port PORT]
  $0 clean

Defaults:
  --api  ${DEFAULT_API}
  --port ${DEFAULT_PORT}
USAGE
}

die() { echo "[error] $*" >&2; exit 2; }

sanitize_name() {
  local s
  s="$(basename "$1")"
  s="${s%.yaml}"
  s="${s%.yml}"
  s="$(echo "$s" | tr '[:upper:]' '[:lower:]')"
  s="$(echo "$s" | sed -E 's/[^a-z0-9._-]+/-/g' | sed -E 's/^-+|-+$//g')"
  echo "$s"
}

ensure_per_test_layout() {
  local test_name="$1"
  local base="${ROOT_DIR}/wiremock/${test_name}"
  local maps="${base}/mappings"
  local files="${base}/__files"
  local assets="${files}/assets"

  mkdir -p "${maps}" "${assets}"

  for d in mappings __files; do
    local shared="${ROOT_DIR}/wiremock/${d}"
    local target="${base}/${d}"
    if [[ -L "${shared}" ]]; then
      rm -f "${shared}"
    elif [[ -d "${shared}" ]]; then
      if [[ -n "$(ls -A "${shared}" 2>/dev/null || true)" ]]; then
        local ts="$(date +%Y%m%d-%H%M%S)"
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

point_shared_symlinks() {
  local test_name="$1"
  local base="${ROOT_DIR}/wiremock/${test_name}"
  for d in mappings __files; do
    local shared="${ROOT_DIR}/wiremock/${d}"
    local target="${base}/${d}"
    [[ -d "${target}" ]] || die "Expected directory not found: ${target}"
    if [[ -L "${shared}" ]]; then
      rm -f "${shared}"
    elif [[ -d "${shared}" ]]; then
      if [[ -n "$(ls -A "${shared}" 2>/dev/null || true)" ]]; then
        local ts="$(date +%Y%m%d-%H%M%S)"
        local backup="${ROOT_DIR}/wiremock/_backup-${ts}-${d}"
        echo "[info] Moving existing ${shared} to ${backup}"
        mv "${shared}" "${backup}"
      else
        rmdir "${shared}" || true
      fi
    fi
    ln -s "${target}" "${shared}"
  done
}

assert_stub_exists() {
  local test_name="$1"
  local base="${ROOT_DIR}/wiremock/${test_name}"
  local maps="${base}/mappings"

  if [[ ! -d "${maps}" ]]; then
    echo "[error] Stubs for test '${test_name}' not found: directory ${maps} does not exist." >&2
    echo "Hint: verify test name or record stubs first using the 'record' command." >&2
    exit 2
  fi

  shopt -s nullglob
  local jsons=("${maps}"/*.json)
  shopt -u nullglob
  if [[ ${#jsons[@]} -eq 0 ]]; then
    echo "[error] Stubs for test '${test_name}' are empty: no JSON mappings in ${maps}." >&2
    echo "Hint: record stubs first using the 'record' command." >&2
    exit 2
  fi
}

stub_exists_nonfatal() {
  local test_name="$1"
  local base="${ROOT_DIR}/wiremock/${test_name}"
  local maps="${base}/mappings"
  if [[ ! -d "${maps}" ]]; then
    return 1
  fi
  shopt -s nullglob
  local jsons=("${maps}"/*.json)
  shopt -u nullglob
  [[ ${#jsons[@]} -gt 0 ]]
}

wait_wiremock_ready() {
  local base="${1:-http://127.0.0.1:8080}"
  local retries=60 i=0
  until curl -sS -m 1 "${base}/__admin/mappings" >/dev/null 2>&1; do
    i=$((i+1))
    if [[ $i -ge $retries ]]; then
      echo "[warn] WireMock not ready after ${retries}s; continuing anyway."
      return 0
    fi
    sleep 1
  done
}

is_flow_file() {
  local p="$1"
  [[ -f "$p" ]] && [[ "$p" =~ \.ya?ml$ ]]
}

list_flows_in_dir() {
  local dir="$1"
  local -a items=()
  while IFS= read -r -d '' f; do
    items+=("$f")
  done < <(find "$dir" -maxdepth 1 -type f \( -name "*.yaml" -o -name "*.yml" \) -print0 | sort -z)
  printf '%s\0' "${items[@]}"
}

record_single_flow() {
  local FLOW_PATH="$1"
  local API="$2"
  local PORT="$3"
  local INSECURE="$4"

  local TEST_NAME TEST_ROOT
  TEST_NAME="$(sanitize_name "${FLOW_PATH}")"
  TEST_ROOT="$(ensure_per_test_layout "${TEST_NAME}")"
  echo "[record] Test name: ${TEST_NAME}"
  echo "[record] Per-test dir: ${TEST_ROOT}"

  export REAL_API_BASE="${API}"
  echo "[record] Starting WireMock recorder (upstream: ${REAL_API_BASE})..."
  docker compose -f "${COMPOSE}" up -d wiremock-record
  wait_wiremock_ready "http://127.0.0.1:${PORT}"

  export WIREMOCK_BASE="http://127.0.0.1:${PORT}"
  echo "[record] WIREMOCK_BASE=${WIREMOCK_BASE}"

  if command -v maestro >/dev/null 2>&1; then
    echo "[record] Running Maestro flow: ${FLOW_PATH}"
    maestro test -e WIREMOCK_BASE="${WIREMOCK_BASE}" -e REAL_API_BASE="${REAL_API_BASE}" "${FLOW_PATH}"
  else
    echo "[warn] 'maestro' CLI not found in PATH – skipping flow run."
  fi

  if [[ "${INSECURE}" == "1" ]]; then
    export LOCALIZE_IMAGES_INSECURE=1
  fi
  echo "[record] Localizing images into ${TEST_ROOT}/__files/assets ..."
  python3 "${ROOT_DIR}/tools/localize_images.py" \
    --base "${TEST_ROOT}" \
    --placeholder "${ROOT_DIR}/tools/placeholder.png" || true

  echo "[record] Shutting down WireMock..."
  docker compose -f "${COMPOSE}" down || true
  echo "[record] Done. Stubs saved under: wiremock/${TEST_NAME}/"
}

playback_single_flow() {
  local FLOW_PATH="$1"
  local PORT="$2"

  local TEST_NAME TEST_ROOT
  TEST_NAME="$(sanitize_name "${FLOW_PATH}")"

  if ! stub_exists_nonfatal "${TEST_NAME}"; then
    echo "[playback][skip] Missing stubs for ${TEST_NAME}"
    return 2
  fi

  TEST_ROOT="${ROOT_DIR}/wiremock/${TEST_NAME}"
  echo "[playback] Using stubs for: ${TEST_NAME} at ${TEST_ROOT}"

  point_shared_symlinks "${TEST_NAME}"

  echo "[playback] Starting WireMock (read-only mappings)..."
  docker compose -f "${COMPOSE}" up -d wiremock-playback
  wait_wiremock_ready "http://127.0.0.1:${PORT}"

  export WIREMOCK_BASE="http://127.0.0.1:${PORT}"
  if command -v maestro >/dev/null 2>&1; then
    echo "[playback] Running Maestro flow: ${FLOW_PATH}"
    maestro test -e WIREMOCK_BASE="${WIREMOCK_BASE}" "${FLOW_PATH}"
  else
    echo "[warn] 'maestro' CLI not found in PATH – skipping flow run."
  fi

  docker compose -f "${COMPOSE}" down || true
  echo "[playback] Done for ${TEST_NAME}."
  return 0
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

    if [[ -d "${FLOW}" ]]; then
      echo "[record] Directory mode: ${FLOW}"
      FLOWS=()
while IFS= read -r -d '' f; do
  FLOWS+=("$f")
done < <(list_flows_in_dir "${FLOW}")
      if [[ ${#FLOWS[@]} -eq 0 ]]; then
        die "No *.yaml or *.yml found in ${FLOW}"
      fi
      echo "[record] Found ${#FLOWS[@]} flows"
      set +e
      total=${#FLOWS[@]}
      ok=0
      fail=0
      for f in "${FLOWS[@]}"; do
        echo "------------------------------------------------------------"
        echo "[record] Processing: ${f}"
        record_single_flow "${f}" "${API}" "${PORT}" "${INSECURE}"
        rc=$?
        if [[ $rc -eq 0 ]]; then ok=$((ok+1)); else fail=$((fail+1)); fi
      done
      set -e
      echo "------------------------------------------------------------"
      echo "[record][summary] total=${total} ok=${ok} failed=${fail}"
      [[ $fail -eq 0 ]] || exit 1
    else
      is_flow_file "${FLOW}" || die "Flow path is not a YAML file: ${FLOW}"
      record_single_flow "${FLOW}" "${API}" "${PORT}" "${INSECURE}"
    fi
    ;;

  playback)
    [[ -n "${FLOW}" ]] || die "--flow is required for 'playback'"

    if [[ -d "${FLOW}" ]]; then
      echo "[playback] Directory mode: ${FLOW}"
      FLOWS=()
        while IFS= read -r -d '' f; do
    FLOWS+=("$f")
done < <(list_flows_in_dir "${FLOW}")
      if [[ ${#FLOWS[@]} -eq 0 ]]; then
        die "No *.yaml or *.yml found in ${FLOW}"
      fi
      echo "[playback] Found ${#FLOWS[@]} flows"
      set +e
      total=${#FLOWS[@]}
      played=0
      missing=0
      failed=0
      for f in "${FLOWS[@]}"; do
        echo "------------------------------------------------------------"
        echo "[playback] Processing: ${f}"
        playback_single_flow "${f}" "${PORT}"
        rc=$?
        case "$rc" in
          0) played=$((played+1));;
          2) missing=$((missing+1));;
          *) failed=$((failed+1));;
        esac
      done
      set -e
      echo "------------------------------------------------------------"
      echo "[playback][summary] total=${total} played=${played} missing_stubs=${missing} failed=${failed}"
      [[ $failed -eq 0 ]] || exit 1
    else
      is_flow_file "${FLOW}" || die "Flow path is not a YAML file: ${FLOW}"
      # Fatal validation for single-file mode
      TEST_NAME="$(sanitize_name "${FLOW}")"
      assert_stub_exists "${TEST_NAME}"
      playback_single_flow "${FLOW}" "${PORT}"
    fi
    ;;

  clean)
    echo "[clean] Stopping containers and cleaning temp image mappings..."
    docker compose -f "${COMPOSE}" down || true
    if [[ -d "${ROOT_DIR}/wiremock/mappings" ]]; then
      find "${ROOT_DIR}/wiremock/mappings" -maxdepth 1 -name 'img-*.json' -delete || true
    fi
    echo "[clean] Done."
    ;;

  *)
    usage
    exit 2;;
esac
