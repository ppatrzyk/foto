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
    -ImageWidth \
    -ImageHeight \
    -Software \
    -Rights \
    -Copyright \
    $dir/* | jq '[.[] | {(.SourceFile):.}] | add' > exif.json

cat exif.json | jq -r 'to_entries[] | "\(.key) \(.value.ImageWidth) \(.value.ImageHeight)"' | \
while read line
do
    read -r path width height <<<$(echo $line)
    echo " path $path width $width height $height"
    if (( width > height ))
    then
        ratio=$(jq -n 1000/$width)
        target_width=1000
        target_height=$(jq -n "$height*$ratio | floor")
    else
        ratio=$(jq -n 1000/$height)
        target_height=1000
        target_width=$(jq -n "$width*$ratio | floor")
    fi
    echo " TARGET width $target_width height $target_height"
done
