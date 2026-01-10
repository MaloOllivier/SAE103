#!/bin/bash

# Nom du volume
VOLUME=$3
# Image
IMAGE=$2
# Chemain du dossier
CHEMIN=$1
# Logs
LOGS="../logs.txt"
# Creation du volume && du fichier LOGS
docker volume create $VOLUME >> $LOGS
echo "Malo OLLIVIER - IUT LANNION 2025-2026" >> $LOGS

# Container de transfert pour copier tous les fichier
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

# Boucle pour tous les fichiers en .xlsx présent dans le dossier
cd $CHEMIN/depot
for FICH in *.xlsx; do
  NOMFICH=$(basename "$FICH" .xlsx)
  echo --------------
  echo "Conversion de '$FICH' --> '$NOMFICH.csv'"

  # Copie du fichier dans le container TRANSFERT
  docker cp "$FICH" $TRANSFERT:/data/"$FICH" >> $LOGS

  # Conversion des xlsx en csv
  docker run --rm -v $VOLUME:/data $IMAGE sh -c "ssconvert \"/data/$FICH\" \"/data/$NOMFICH.csv\""

  echo "✓ \"$NOMFICH\" converti en csv"
  echo "Nettoyage de '$FICH' ..."
  docker run --rm -v $VOLUME:/data $IMAGE php /data/nettoyage_CSV.php /data/"$NOMFICH.csv"
  docker cp $TRANSFERT:/data/"$NOMFICH.csv" "$CHEMIN/resultat/" >> $LOGS
done

# Suppression du container de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS

echo --------------
echo "Tous les fichiers .xlsx ont été convertis !"
