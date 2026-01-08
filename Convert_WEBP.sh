#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

shopt -s nullglob

IMAGE_MAX_SIZE="900x620"
MAX_WEIGHT=180000

INPUT_DIR="fichiers"
OUTPUT_DIR="resultat"

mkdir -p "$OUTPUT_DIR"

for img in "$INPUT_DIR"/*.jpg; do
    filename=$(basename "$img")
    name="${filename%.*}"

    echo "▶ Traitement de $filename"

    docker run --rm \
      -v "$SCRIPT_DIR/$INPUT_DIR:/data/in" \
      -v "$SCRIPT_DIR/$OUTPUT_DIR:/data/out" \
      sae103-imagick \
      "/data/in/$filename" \
      -resize "${IMAGE_MAX_SIZE}>" \
      -quality 90 \
      "/data/out/$name.webp"

    # Vérification
    if [ ! -f "$OUTPUT_DIR/$name.webp" ]; then
        echo "❌ Image non générée : $name.webp"
        continue
    fi

    for q in 85 80 75 70 65; do
        size=$(stat -c%s "$OUTPUT_DIR/$name.webp")

        [ "$size" -le "$MAX_WEIGHT" ] && break

        docker run --rm \
          -v "$SCRIPT_DIR/$OUTPUT_DIR:/data/out" \
          sae103-imagick \
          "/data/out/$name.webp" \
          -quality "$q" \
          "/data/out/$name.webp"
    done

    final_size=$(stat -c%s "$OUTPUT_DIR/$name.webp")
    echo "✔ $filename → $final_size octets"
done
