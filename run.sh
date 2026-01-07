#!/bin/bash
# Logs
LOGS="logs.txt"
touch $LOGS
# Image
IMAGE="bigpapoo/sae103-excel2csv:latest"
# Nom du volume
VOLUME="SAE103_MALOOLLIVIER"
CHEMIN=$(pwd)
# Container de transfert pour copier tous les fichier
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS
docker cp "DEPTS" $TRANSFERT:/data/"DEPTS" >> $LOGS
docker cp "REGIONS" $TRANSFERT:/data/"REGIONS" >> $LOGS
docker cp "nettoyage.php" $TRANSFERT:/data/nettoyage.php >> $LOGS
cd fichiers/
for FICH in *.xlsx; do
  NOMFICH=$(basename "$FICH" .xlsx)
  echo --------------
  echo "Conversion de '$FICH' --> '$NOMFICH.csv'"

  # Copie du fichier dans le container TRANSFERT
  docker cp "$FICH" $TRANSFERT:/data/"$FICH" >> $LOGS

  # Conversion des xlsx en csv
  docker run --rm -v $VOLUME:/data $IMAGE sh -c "ssconvert \"/data/$FICH\" \"/data/$NOMFICH.csv\""

  echo "✓ \"$NOMFICH\" converti en csv"
done
# faut recup le nom du fichier
docker run --rm -v $VOLUME:/data $IMAGE php /data/nettoyage.php /data/$NOMFICH.csv
docker cp $TRANSFERT:/data/"$NOMFICH.csv" "$CHEMIN/resultat/" >> $LOGS
# Suppression du docker de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS