#!/bin/php
<?php

if ($argc < 2) {
    echo "Usage : charger_fichier.php fichier.csv\n";
    exit(1);
}

$fichier = $argv[1];
echo $fichier;
/* Chargement du fichier : 1 ligne = 1 cellule */
$lignes = file($fichier);
array_shift($lignes);
array_shift($lignes);
array_shift($lignes);
# $lignesDEPTS = file("DEPTS");
# $nbLignes = count($lignesDEPTS);
# echo "Nombre de lignes : $nbLignes\n";

/* Nettoyage et stockage dans un tableau */
$tableau = [];

foreach ($lignes as $ligne) {
    $ligne = rtrim($ligne);   // enlève le \n
    $cellules = explode(",", $ligne); // découpe en cellules
    $tableau[] = $cellules;
}
echo $fichier;

$fich = fopen($fichier, 'w');

if ($fich) {
    foreach ($tableau as $ligne_tableau) {
        // fputcsv attend un TABLEAU pour la ligne 
        fputcsv($fich, $ligne_tableau);
    }
    fclose($fich);
}
/* Affichage pour vérification */
# print_r($tableau);
?>