#!/usr/bin/env bash
set -euo pipefail

# Helper: extract full hash of a submodule by path/name
submodule_commit() {
  local name="$1"
  git submodule status --recursive |
    awk -v name="$name" '
      $2 == name {
        gsub(/^[-+ ]/, "", $1)
        print substr($1, 1, 8)
      }
    '
}

protocol_commit=$(submodule_commit "protocol-go/protocol")
chuckd_commit=$(submodule_commit "chuckd")
protocol_go_commit=$(submodule_commit "protocol-go")

COMMIT_MSG="protocol=${protocol_commit} chuckd=${chuckd_commit} protocol-go=${protocol_go_commit}"
git commit -m "${COMMIT_MSG}"
