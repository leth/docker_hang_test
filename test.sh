#!/bin/bash -ex

cd "$(dirname $0)"

docker build -t tester .
docker build -t test_built tester/test_build
[ -e cache ] || mkdir cache
docker save -o cache/ubuntu ubuntu:14.04
docker save -o cache/test_built test_built
docker run --rm --privileged --volume=`pwd`/cache:/cache tester