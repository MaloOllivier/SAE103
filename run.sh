#!/bin/bash
# Logs
LOGS="scripts/logs.txt"
touch $LOGS
# Image
IMAGE="bigpapoo/sae103-excel2csv"
# Nom du volume
VOLUME="SAE103_MALOOLLIVIER"
CHEMIN=$(pwd)
# Container de transfert pour copier tous les fichier
# docker image pull $IMAGE
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS
docker cp "data/DEPTS" $TRANSFERT:/data/"DEPTS" >> $LOGS
docker cp "data/REGIONS" $TRANSFERT:/data/"REGIONS" >> $LOGS
docker cp "scripts/text2html.php" $TRANSFERT:/data/text2html.php >> $LOGS
./scripts/Convertisseur_CSV.sh $(pwd) $IMAGE $VOLUME
./scripts/nettoyage_text.sh $(pwd) $IMAGE $VOLUME
./scripts/conversion_images.sh $(pwd) $VOLUME
# Suppression du docker de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS