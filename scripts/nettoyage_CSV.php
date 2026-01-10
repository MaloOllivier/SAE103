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

$lignesDEPTS = file("/data/DEPTS");
$nbDepts = count($lignesDEPTS);

for ($i = 1; $i < $nbDepts; $i++) {
    $trouve = false;

    foreach ($tableau_propre as $ligne) {
        if ($ligne[1] == $i || $i == 20) {
            $trouve = true;
            break;
        }
    }

    if ($trouve == false) {
        $tableau_propre[] = ["", $i, ""]; 
    }
}

foreach ($tableau_propre as $indice => $ligne) { 
    if ($ligne[1] == "2A") {
        $tableau_propre[$indice][1] = "20.1"; // On modifie directement dans le tableau principal
    } elseif ($ligne[1] == "2B") {
        $tableau_propre[$indice][1] = "20.2";
    }
}

$lignes_finales = [];
foreach ($tableau_propre as $ligne_tab) {
    // On remets les guillemets au debut et a la fin de la premiere case (nom du site)
    $ligne_tab[0] = '"' . $ligne_tab[0] . '"';
    // On fusionne les cellules en les séparant par des virgules
    $lignes_finales[] = implode(",", $ligne_tab);
}

file_put_contents($fichier, implode("\n", $lignes_finales) . "\n");

shell_exec("sort -t',' -k 2,2 -n -r \"$fichier\" -o \"$fichier\"");

// On recharge le fichier trié dans un tableau propre
$lignes_triees = file($fichier);
$tableau_final = [];

foreach ($lignes_triees as $ligne) {
    $ligne = rtrim($ligne);
    $cellules = explode(",", $ligne);
    
    // On vérifie la case du département (indice 1)
    if ($cellules[1] == "20.1") {
        $cellules[1] = "2A";
    }
    if ($cellules[1] == "20.2") {
        $cellules[1] = "2B";
    }
    
    // 3. On reconstruit la ligne et on l'ajoute au tableau final
    $tableau_final[] = implode(",", $cellules);
}

// 4. On écrase le fichier avec les bonnes valeurs
file_put_contents($fichier, implode("\n", $tableau_final));
echo "✓ $fichier a été nettoyé.\n";
?>