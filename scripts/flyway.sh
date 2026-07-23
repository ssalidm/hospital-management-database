#!/usr/bin/env bash

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <info|validate|migrate|baseline|repair>"
  exit 1
fi

docker compose run --rm flyway "$@"