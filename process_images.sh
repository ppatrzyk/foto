#!/usr/bin/env bash

set -e
dir=$1

# TODO? do not overwrite ready images?
if [ -d "./static/images" ]; then
    rm -rf ./static/images
fi
mkdir ./static/images
if [ -d "./static/thumbs" ]; then
    rm -rf ./static/thumbs
fi
mkdir ./static/thumbs

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
    $dir/* | \
    jq '[
        .[] |
        {
            (.SourceFile):
            (
                . +
                if .ImageWidth > .ImageHeight then
                {WebWidth: 1000, WebHeight: (.ImageHeight*(1000/.ImageWidth)) | floor}
                else
                {WebWidth: (.ImageWidth*(1000/.ImageHeight)) | floor, WebHeight: 1000}
                end +
                {ThumbWidth: (.ImageWidth*(200/.ImageHeight)) | floor, ThumbHeight: 200}
            )
        }
    ] | add' > ./data/exif.json

cat ./data/exif.json | jq -r 'to_entries[] | "\(.key) \(.value.WebWidth) \(.value.WebHeight)"' | \
while read line
do
    read -r path web_width web_height <<<$(echo $line)
    echo "Processing $path"
    base_name=$(basename ${path})
    gm convert -size "${web_width}x${web_height}" $path -resize "${web_width}x${web_height}" +profile "*" "./static/images/$base_name"
    gm convert "./static/images/$base_name" -resize x200 +profile "*" "./static/thumbs/$base_name"
done
