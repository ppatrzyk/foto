#!/usr/bin/env bash

set -e
dir=$1

exiftool -j \
    -SubSecDateTimeOriginal \
    -Make \
    -Model \
    -LensID \
    -LensSpec \
    -LensType \
    -Lens \
    -MaxApertureValue \
    -FocalLength \
    -FNumber \
    -ExposureProgram \
    -MeteringMode \
    -ExposureTime \
    -ShutterSpeed \
    -ISO \
    -Flash \
    -Software \
    -Rights \
    -Copyright \
    $dir/* | jq '[.[] | {(.SourceFile):.}] | add' > exif.json