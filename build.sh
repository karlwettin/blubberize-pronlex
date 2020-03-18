#!/bin/sh

# clean up previous builds
docker rm wikispeech-pronlex
docker rmi wikispeech-pronlex

# build docker
~/opt/blubber pronlex.yaml production | docker build --tag wikispeech-pronlex --file - .
