#!/bin/php
<?php

if ($argc < 2) {
    echo "Usage : nettoyage.php fichier.csv\n";
    exit(1);
}

$fichier = $argv[1];

$lignes = file($fichier);

// Suppression du titre et de l'entete
array_shift($lignes);
array_shift($lignes);
array_shift($lignes);

$tableau_propre = [];

foreach ($lignes as $ligne) {
    $ligne = rtrim($ligne); // On enleve les retours a la ligne pour ne pas avoir de cases vide.
    $cellules = explode(",", $ligne); // Decoupage des cases a chaque virgule

    $cellules_nettoyee = [];
    foreach ($cellules as $cellule) {
        $cellules_nettoyee[] = trim($cellule, '"'); // On enleve les guillemets et on mets nos cellules dans un noveau tableau
    }
    $tableau_propre[] = $cellules_nettoyee; // On met toutes no cellules dans un seul et meme tableau
}

$lignes_finales = [];
foreach ($tableau_propre as $ligne_tab) {
    // On remets les guillemets au debut et a la fin de la premiere case (nom du site)
    $ligne_tab[0] = '"' . $ligne_tab[0] . '"';
    // On fusionne les cellules en les séparant par des virgules
    $lignes_finales[] = implode(",", $ligne_tab);
}


file_put_contents($fichier, implode("\n", $lignes_finales) . "\n");

echo "$fichier a été nettoye.\n";
?>