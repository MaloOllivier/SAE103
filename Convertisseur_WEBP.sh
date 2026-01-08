#!/bin/bash

# Nom du volume
VOLUME="SAE103_MALOOLLIVIER"
# Image
IMAGE="sae103-jpg2webp"
# Chemain du dossier
CHEMIN=$(pwd)
# Logs
LOGS="logs.txt"
# Creation du volume && du fichier LOGS
docker volume create $VOLUME >> $LOGS
echo "Malo OLLIVIER - IUT LANNION 2025-2026" > $LOGS

# Container de transfert pour copier tous les fichier
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

# Boucle pour tous les fichiers en .webp présent dans le dossier
for FICH in *.jpg; do
  NOMFICH=$(basename "$FICH" .jpg)
  echo --------------
  echo "Conversion de '$FICH' --> '$NOMFICH.webp'"

  # Copie du fichier dans le volume par l'intermidère du conteneur de transfert
  docker cp "$FICH" $TRANSFERT:/data/"$FICH" >> $LOGS

  # Conversion des jpg en webp
  docker run --rm -v $VOLUME:/data $IMAGE sh -c "weasyprint \"/data/$FICH\" \"/data/$NOMFICH.webp\""

  # Recuperation des fichiers convertis
  docker cp $TRANSFERT:/data/"$NOMFICH.webp" "$CHEMIN" >> $LOGS

  echo "✓ \"$NOMFICH\" converti en webp"
done

# Suppression du docker de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS

echo --------------
echo "Tous les fichiers .jpg ont été convertis !"
