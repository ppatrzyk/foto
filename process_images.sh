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
                {WebWidth: 1200, WebHeight: (.ImageHeight*(1200/.ImageWidth)) | floor}
                else
                {WebWidth: (.ImageWidth*(1200/.ImageHeight)) | floor, WebHeight: 1200}
                end
            )
        }
    ] | add' > ./data/exif.json

cat ./data/exif.json | jq -r 'to_entries[] | "\(.key) \(.value.WebWidth) \(.value.WebHeight)"' | \
while read line
do
    read -r path web_width web_height <<<$(echo $line)
    echo "Processing $path"
    base_name=$(basename ${path})
    gm convert \
        -size "${web_width}x${web_height}" $path \
        -resize "${web_width}x${web_height}" +profile "*" \
        -gravity SouthEast -fill "rgb(204, 204, 204)" -font "/usr/share/fonts/truetype/ubuntu/Ubuntu-M.ttf" -pointsize 12 -draw 'text 10,10 "© Piotr Patrzyk"' \
        "./static/images/$base_name"
    gm convert "./static/images/$base_name" -resize x200 +profile "*" "./static/thumbs/$base_name"
done