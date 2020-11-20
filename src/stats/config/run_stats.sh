#!/bin/sh
set -e

echo "BEGIN R"
Rscript /srv/src/R/main.R
echo "END R"
echo "BEGIN python"
python /srv/src/python/main.py
echo "END python"
