FICH="presentation_musee_louvre"
CHEMIN=$1
LOGS="logs.txt"
IMAGE=$2
VOLUME=$3
echo --------------
echo "Nettoyage et conversion en html de '$FICH'..."
sed 's/TITLE=//g' $CHEMIN/depot/$FICH | sed 's/SECT=//g' | sed 's/TEXT=//g' | sed 's/SUB_//g' > $CHEMIN/resultat/$FICH

TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

# Copie du fichier dans le container TRANSFERT
docker cp "$CHEMIN/resultat/$FICH" $TRANSFERT:/data/"$FICH" >> $LOGS

docker run --rm -v $VOLUME:/data $IMAGE php /data/text2html.php /data/"$FICH"
docker cp $TRANSFERT:/data/"$FICH" "$CHEMIN/resultat/" >> $LOGS

# Suppression du container de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS