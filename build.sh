#!/usr/bin/env bash

# exit on error
set -e

mkdir -v part0
cd part0

# count number of lines
total="$(wc -l ../base64-images.txt | rev | cut -d " " -f 2 | rev)"
((total--)) || true

# width_height_
prefix="768_1280_"

count="0"
while read -r line; do
  echo "Processing image $count/$total"
  # add 5 digit padding
  number="$(python -c 'import sys; print(sys.argv[1].zfill(5))' "$count")"
  # file name
  name="${prefix}${number}.png"
  # extract the image
  echo "$line" | base64 --decode > "$name"
  # resize and add overlay
  convert "$name" -resize 768x1280 "../overlay.png" -composite "$name"
  # increase counter, don't return 1
  ((count++)) || true
done < ../base64-images.txt