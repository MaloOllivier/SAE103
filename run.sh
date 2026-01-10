#!/bin/bash
# Logs
LOGS="../logs.txt"
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
docker cp "DEPTS" $TRANSFERT:/data/"DEPTS" >> $LOGS
docker cp "REGIONS" $TRANSFERT:/data/"REGIONS" >> $LOGS
docker cp "nettoyage.php" $TRANSFERT:/data/nettoyage.php >> $LOGS
./Convertisseur_CSV.sh

# Suppression du docker de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS