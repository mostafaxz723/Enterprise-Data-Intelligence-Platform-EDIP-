#!/usr/bin/env bash
# One command for Mac / Linux / WSL.   bash setup/bootstrap.sh [--role all|data|web] [--full] [--skip-docker]
set -euo pipefail
cd "$(dirname "$0")/.."
ROLE=all; FULL=0; SKIPD=0
while [ $# -gt 0 ]; do case "$1" in --role) ROLE="$2"; shift;; --full) FULL=1;; --skip-docker) SKIPD=1;; esac; shift; done
need() { command -v "$1" >/dev/null || { echo "Missing: $1 ($2)"; exit 1; }; }
need git "https://git-scm.com"
[ -f .env ] || cp .env.example .env
if [[ "$ROLE" == all || "$ROLE" == data ]]; then
  need conda "https://www.anaconda.com/download"
  echo "[1] conda env egypt-energy"
  if conda env list | grep -qE '^egypt-energy\s'; then conda env update -n egypt-energy -f environment.yml
  else conda env create -f environment.yml; fi
  [ -d .git ] && conda run -n egypt-energy pre-commit install || true
  if [ "$SKIPD" = 0 ]; then
    need docker "https://www.docker.com/products/docker-desktop"
    echo "[2] docker images (nothing is started)"
    docker compose --profile "*" config -q
    if [ "$FULL" = 1 ]; then P=(--profile "*"); else P=(--profile airflow); fi
    docker compose "${P[@]}" pull --ignore-buildable
    docker compose "${P[@]}" build
  fi
fi
if [[ "$ROLE" == all || "$ROLE" == web ]]; then
  need node "https://nodejs.org (LTS)"
  echo "[3] website dependencies"; (cd web && npm install)
fi
[[ "$ROLE" != web ]] && conda run -n egypt-energy python setup/check_python.py || true
echo "Done."
