$FICH = "presentation_musee_louvre"
$CHEMIN = $1
$LOGS = "../logs.txt"
$IMAGE = $2
echo "Nettoyage et conversion en html de 'presentation_musee_louvre'..."
sed 's/TITLE=//g' $CHEMIN/depot/$FICH | sed 's/SECT=//g' | sed 's/TEXT=//g' | sed 's/SUB_//g' > $CHEMIN/resultat/presentation_musee_louvre

TRANSFERT="temporaire_$(date +%s%N)"
docker run -dit --name $TRANSFERT -v $VOLUME:/data $IMAGE >> $LOGS

docker run --rm -v $VOLUME:/data $IMAGE php /data/text2html.php /data/"$NOMFICH.csv"
docker cp $TRANSFERT:/data/"$FICH" "$CHEMIN/resultat/" >> $LOGS

# Suppression du container de TRANSFERT
docker rm -f $TRANSFERT >> $LOGS