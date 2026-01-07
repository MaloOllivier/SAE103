#!/bin/php
<?php

if ($argc < 2) {
    echo "Usage : charger_fichier.php fichier.csv\n";
    exit(1);
}

$fichier = $argv[1];

/* Chargement du fichier : 1 ligne = 1 cellule */
$lignes = file($fichier);
array_shift($lignes);
array_shift($lignes);
$lignesDEPTS = file("data/DEPTS");
$nbLignes = count($lignesDEPTS);
echo "Nombre de lignes : $nbLignes\n";

/* Nettoyage et stockage dans un tableau */
$tableau = [];

foreach ($lignes as $ligne) {
    $ligne = rtrim($ligne);   // enlève le \n
    $cellules = explode(",", $ligne); // découpe en cellules
    $tableau[] = $cellules;
}

/* Affichage pour vérification */
// print_r($tableau);
?>