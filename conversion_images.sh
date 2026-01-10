FICH="test.jpg"
CHEMIN=$(pwd)
LOGS="logs.txt"
IMAGE="bigpapoo/sae103-imagick"
VOLUME="SAE103_MALOOLLIVIER"

TRANSFERT="temporaire_$(date +%s%N)"

# Container de transfert
docker run -dit --name "$TRANSFERT" -v "$VOLUME:/data" "$IMAGE" >> "$LOGS"

docker cp "$FICH" "$TRANSFERT:/data/$FICH" >> "$LOGS"

NOMFICH=$(basename "$FICH" .jpg)

# Dimensions de l'image
DIMENSIONS=$(docker run --rm --entrypoint "" -v "$VOLUME:/data" "$IMAGE" identify -format '%wx%h' /data/$FICH)

echo "Les dimensions sont : $DIMENSIONS"


# Conversion en webp avec la bonne taille
docker run --rm --entrypoint "" -v "$VOLUME:/data" "$IMAGE" convert /data/$FICH -resize x620 -quality 80 /data/$NOMFICH.webp

docker cp "$TRANSFERT:/data/$NOMFICH.webp" "$CHEMIN/resultat/" >> "$LOGS"

docker rm -f "$TRANSFERT" >> "$LOGS"
