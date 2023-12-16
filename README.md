# foto

Code for generating my photo gallery

required utilities:
- exiftool
- GraphicsMagick
- jq
- hugo

```
# updates data/exif.json and image files in static
./process_images.sh <path_to_original_jpegs>

# fix metadata for manual lens photo
exiftool -Lens="Tamron SP 70-210mm F/3.5 (Model 19AH)" -overwrite_original <path_to_photo>
```
