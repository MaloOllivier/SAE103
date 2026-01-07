#!/bin/bash

# Nom du volume
VOLUME="Donnees_excel2csv"
# Image
IMAGE="bigpapoo/sae103-excel2csv:latest"
# Chemain du dossier
CHEMAIN=$(pwd)
# Logs
LOGS="logsCSV.txt"
# Creation du volume && du fichier LOGS
touch $LOGS
docker volume create $VOLUME >> $LOGS
echo "Malo OLLIVIER - IUT LANNION 2025-2026" > $LOGS

# Container de transfert pour copier tous les fichier
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

# Boucle pour tous les fichiers en .xlsx présent dans le dossier
for FICH in *.xlsx; do
  NOMFICH=$(basename "$FICH" .xlsx)
  echo --------------
  echo "Conversion de '$FICH' --> '$NOMFICH.csv'"

  # Copie du fichier dans le container TRANSFERT
  docker cp "$FICH" $TRANSFERT:/data/"$FICH" >> $LOGS

  # Conversion des xlsx en csv
  docker run --rm -v $VOLUME:/data $IMAGE sh -c "ssconvert \"/data/$FICH\" \"/data/$NOMFICH.csv\""

  # Recuperation des fichiers convertis
  docker cp $TRANSFERT:/data/"$NOMFICH.csv" "$CHEMAIN" >> $LOGS

  echo "✓ \"$NOMFICH\" converti en csv"
done

# Suppression du docker de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS

echo --------------
echo "Tous les fichiers .xlsx ont été convertis !"
