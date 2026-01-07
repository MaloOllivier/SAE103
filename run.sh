#!/bin/bash
# Logs
LOGS="logs.txt"
touch $LOGS
# Image
IMAGE="bigpapoo/sae103-excel2csv:latest"
# Nom du volume
VOLUME="SAE103_MALOOLLIVIER"
# Container de transfert pour copier tous les fichier
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS
docker cp "DEPTS" $TRANSFERT:/data/"DEPTS" >> $LOGS
docker cp "REGIONS" $TRANSFERT:/data/"REGIONS" >> $LOGS
./Convertisseur_CSV.sh
./Convertisseur_PDF.sh
# Suppression du docker de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS