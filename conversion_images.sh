FICH="test.jpg"
CHEMIN=$(pwd)
LOGS="logs.txt"
IMAGE="bigpapoo/sae103-imagick"
VOLUME="SAE103_MALOOLLIVIER"

TRANSFERT="temporaire_$(date +%s%N)"
# On s'assure que le container de transfert tourne en arrière-plan
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

# 1. Copie du fichier dans le dossier /data du volume via le container de transfert
# Vérifie que test.jpg est bien dans le dossier actuel !
docker cp "$FICH" $TRANSFERT:/data/"$FICH" >> $LOGS

NOMFICH=$(basename "$FICH" .jpg)
DIMENSIONS=$(docker run --rm -v $VOLUME:/data $IMAGE sh -c "identify -format "%wx%h" /data/$FICH")

echo "Les dimensions sont : $DIMENSIONS"
# 2. Correction de la commande magick
# On utilise --workdir /data pour que magick trouve les fichiers directement
# On retire "sh -c" si l'image possède déjà un entrypoint configuré
docker run --rm -v $VOLUME:/data $IMAGE sh -c "convert "/data/$FICH" -resize x620 -quality 80 "/data/$NOMFICH.webp""

# 3. Récupération du fichier produit
docker cp $TRANSFERT:/data/"$NOMFICH.webp" "$CHEMIN/resultat/" >> $LOGS

# Suppression du container de transfert
docker rm -f $TRANSFERT >> $LOGS