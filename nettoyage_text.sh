sed 's/TITLE=//g' depot/presentation_musee_louvre | sed 's/SECT=//g' | sed 's/TEXT=//g' | sed 's/SUB_//g' > resultat/louvre_test
./text2html.php resultat/louvre_test