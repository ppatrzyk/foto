#!/usr/bin/env bash

set -e
dir=$1

# TODO? do not overwrite ready images? dont delete css once ready
if [ -d "./static" ]; then
    rm -rf ./static
fi
mkdir ./static
mkdir ./static/thumbs
mkdir ./static/images

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
    $dir/* | jq '[.[] | {(.SourceFile):.}] | add' > ./data/exif.json

cat ./data/exif.json | jq -r 'to_entries[] | "\(.key) \(.value.ImageWidth) \(.value.ImageHeight)"' | \
while read line
do
    read -r path orig_width orig_height <<<$(echo $line)
    echo "Processing $path"
    base_name=$(basename ${path})
    if (( orig_width > orig_height ))
    then
        ratio=$(jq -n 1000/$orig_width)
        web_width=1000
        web_height=$(jq -n "$orig_height*$ratio | floor")
    else
        ratio=$(jq -n 1000/$orig_height)
        web_height=1000
        web_width=$(jq -n "$orig_width*$ratio | floor")
    fi
    thumbs_width=$(jq -n "$web_width/10 | floor")
    thumbs_height=$(jq -n "$web_height/10 | floor")
    gm convert -size "${web_width}x${web_height}" $path -resize "${web_width}x${web_height}" +profile "*" "./static/images/$base_name"
    gm convert -size "${thumbs_width}x${thumbs_height}" $path -resize "${thumbs_width}x${thumbs_height}" +profile "*" "./static/thumbs/$base_name"
done
