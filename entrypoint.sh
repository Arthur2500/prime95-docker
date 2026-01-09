#!/usr/bin/env bash
set -euo pipefail

cd /opt/prime95

default_flags=${PRIME95_FLAGS:--d}
set -- ${default_flags} "$@"

exec ./mprime "$@"
