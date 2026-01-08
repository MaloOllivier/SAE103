#!/bin/bash

IMAGE_MAX_SIZE="900x620"
MAX_WEIGHT=180000

INPUT_DIR="fichiers"
OUTPUT_DIR="resultat"


for img in "$INPUT_DIR"/*; do
    filename=$(basename "$img")
    name="${filename%.*}"

    echo "▶ Traitement de $filename"

    docker run --rm \
      -v "$(pwd)/$INPUT_DIR:/data/in" \
      -v "$(pwd)/$OUTPUT_DIR:/data/out" \
      sae103-imagick \
      convert "/data/in/$filename" \
        -resize "${IMAGE_MAX_SIZE}>" \
        -quality 90 \
        "/data/out/$name.webp"

    # Boucle de réduction de qualité si nécessaire
    for q in 85 80 75 70 65; do
        size=$(stat -c%s "$OUTPUT_DIR/$name.webp")
        if [ "$size" -le "$MAX_WEIGHT" ]; then
            break
        fi

        docker run --rm \
          -v "$(pwd)/$OUTPUT_DIR:/data/out" \
          sae103-imagick \
          convert "/data/out/$name.webp" \
            -quality "$q" \
            "/data/out/$name.webp"
    done

    final_size=$(stat -c%s "$OUTPUT_DIR/$name.webp")
    echo "✔ $filename → $final_size octets"
done
