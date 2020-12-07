#!/bin/bash
set -e

# This export is needed to make vars available in the env, I really don't know why
export DB_HOST

echo "BEGIN R"
pushd /srv/src/R/
Rscript main.R
popd

echo "END R"
echo "BEGIN python"
python /srv/src/python/main.py
echo "END python"
