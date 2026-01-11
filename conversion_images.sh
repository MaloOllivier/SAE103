FICH="Untitled.png"
CHEMIN=$(pwd)
LOGS="logs.txt"
IMAGE="bigpapoo/sae103-imagick"
VOLUME="SAE103_MALOOLLIVIER"

TRANSFERT="temporaire_$(date +%s%N)"

# Container de transfert
docker run -dit --name "$TRANSFERT" -v "$VOLUME:/data" "$IMAGE" >> "$LOGS"
docker cp "$FICH" "$TRANSFERT:/data/$FICH" >> "$LOGS"

NOMFICH=$(basename "$FICH" .png)

# Dimensions de l'image
LARGEUR=$(docker run --rm --entrypoint "" -v "$VOLUME:/data" "$IMAGE" identify -format '%w' /data/$FICH)
HAUTEUR=$(docker run --rm --entrypoint "" -v "$VOLUME:/data" "$IMAGE" identify -format '%h' /data/$FICH)
echo "Les dimensions sont h: $HAUTEUR et l: $LARGEUR"
H_MAX=620
L_MAX=900
H_MIN=250
L_MIN=350
if [ $LARGEUR -gt $L_MAX ] || [ $HAUTEUR -gt $H_MAX ]; then
    # Calcul du ratio pour respecter les dimensions

    RATIO_L=$(( $L_MAX * 1000 / LARGEUR ))
    RATIO_H=$(( $H_MAX * 1000 / HAUTEUR ))

    # Comparer pour prendre le plus petit
    if [ $RATIO_L -lt $RATIO_H ]; then
        RATIO=$RATIO_L
    else
        RATIO=$RATIO_H
    fi

    # Nouvelle largeur et hauteur
    L_FINAL=$(( $LARGEUR * $RATIO / 1000 ))
    H_FINAL=$(( $HAUTEUR * $RATIO / 1000 ))
    echo "Les nouvelles dimensions sont h: $H_FINAL et l: $L_FINAL"

    # Conversion en webp avec la bonne taille et une qualité réduite
    docker run --rm --entrypoint "" -v "$VOLUME:/data" "$IMAGE" convert /data/$FICH -resize "${L_FINAL}x${H_FINAL}" -quality 90 /data/$NOMFICH.webp
elif [ $LARGEUR -lt $L_MIN ] || [ $HAUTEUR -lt $H_MIN ]; then
   # Calcul du ratio pour respecter les dimensions

    RATIO_L=$(( $L_MIN * 1000 / LARGEUR ))
    RATIO_H=$(( $H_MIN * 1000 / HAUTEUR ))

    # Comparer pour prendre le plus petit
    if [ $RATIO_L -lt $RATIO_H ]; then
        RATIO=$RATIO_L
    else
        RATIO=$RATIO_H
    fi

    # Nouvelle largeur et hauteur
    L_FINAL=$(( $LARGEUR * $RATIO / 1000 ))
    H_FINAL=$(( $HAUTEUR * $RATIO / 1000 ))
    echo "Les nouvelles dimensions sont h: $H_FINAL et l: $L_FINAL"

    # Conversion en webp avec la bonne taille et une qualité réduite
    docker run --rm --entrypoint "" -v "$VOLUME:/data" "$IMAGE" convert /data/$FICH -resize "${L_FINAL}x${H_FINAL}" /data/$NOMFICH.webp
fi

docker cp "$TRANSFERT:/data/$NOMFICH.webp" "$CHEMIN/resultat/" >> "$LOGS"

docker rm -f "$TRANSFERT" >> "$LOGS"