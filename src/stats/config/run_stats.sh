#!/bin/bash
set -e

echo "BEGIN R"
pushd /srv/src/R/
Rscript main.R
popd
echo "END R"
echo "BEGIN python"
python /srv/src/python/main.py
echo "END python"
