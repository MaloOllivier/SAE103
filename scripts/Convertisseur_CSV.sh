#!/bin/bash

# Nom du volume
VOLUME=$3
# Image
IMAGE=$2
# Chemain du dossier
CHEMIN=$1
# Logs
LOGS="$CHEMIN/scripts/logs.txt"
# Creation du volume && du fichier LOGS
docker volume create $VOLUME >> $LOGS

# Container de transfert pour copier tous les fichier
TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

docker cp "scripts/nettoyage_CSV.php" $TRANSFERT:/data/nettoyage_CSV.php >> $LOGS
docker cp "scripts/csv2html.php" $TRANSFERT:/data/csv2html.php >> $LOGS
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


  # Version sites-visites.csv
  sort -t',' -k 4,4 -n "$CHEMIN/resultat/$NOMFICH.csv" > "$CHEMIN/resultat/sites-visites.csv"
  sed -i '1iNom du site,Nom du Departement,Code du departement,Visiteurs annuels' "$CHEMIN/resultat/sites-visites.csv"
  docker cp "$CHEMIN/resultat/sites-visites.csv" $TRANSFERT:/data/sites-visites.csv >> $LOGS
  docker run --rm -v $VOLUME:/data $IMAGE php /data/csv2html.php "/data/sites-visites.csv" "sites-visites"
  docker cp $TRANSFERT:/data/sites-visites.html "$CHEMIN/resultat/" >> $LOGS
  rm "$CHEMIN/resultat/sites-visites.csv"

  # Version sites-dept.csv
  cat "$CHEMIN/resultat/$NOMFICH.csv" > "$CHEMIN/resultat/sites-dept.csv"
  sed -i '1iNom du site,Nom du Departement,Code du departement,Visiteurs annuels' "$CHEMIN/resultat/sites-dept.csv"
  
  docker cp "$CHEMIN/resultat/sites-dept.csv" $TRANSFERT:/data/sites-dept.csv >> $LOGS
  docker run --rm -v $VOLUME:/data $IMAGE php /data/csv2html.php "/data/sites-dept.csv" "sites-dept"
  docker cp $TRANSFERT:/data/sites-dept.html "$CHEMIN/resultat/" >> $LOGS
  #rm "$CHEMIN/resultat/sites-dept.csv"
  rm "$CHEMIN/resultat/$NOMFICH.csv"
done

# Suppression du container de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS

echo --------------
echo "Tous les fichiers .xlsx ont été convertis !"
