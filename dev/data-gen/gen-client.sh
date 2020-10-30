#!/bin/bash
tmp=$(mktemp -d)
echo $tmp
wget https://github.com/hzi-braunschweig/SORMAS-Project/releases/download/v1.49.1/sormas_1.49.1.zip -P "$tmp"
unzip "$tmp/sormas_1.49.1.zip" -d "$tmp"
cp "$tmp/deploy/openapi/sormas-rest.yaml" .
rm -rf "$tmp"


sed -i 's/basic-auth/basicAuth/g' sormas-rest.yaml

docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
-i local/sormas-rest.yaml \
-g python \
-o /local/out \
--package-name sormas

sudo chown -R $USER:$USER out

python3 -m venv venv
source ./venv/bin/activate

pushd out || exit
python3 setup.py install
popd || exit

