#!/bin/php
<?php

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


$lignesDEPTS = file("/data/DEPTS"); // ajout des departements manquants
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
        $tableau_propre[] = ["", $i, 0]; 
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
    // On fusionne les cellules en les séparant par des virgules
    $lignes_finales[] = implode(",", $ligne_tab);
}

file_put_contents($fichier, implode("\n", $lignes_finales) . "\n");


$tableau_depts = [];

foreach ($tableau_propre as $index => $ligne) { // ajout des noms de departements
    $nouvelle_ligne = $ligne;
    // On récupère le code du departement, et on enleve les potentiels espaces
    $code_dep = trim($ligne[1]); 
    // Recherche du nom du departement
    if ($code_dep == "20.1") {
        $nom_dept = $lignesDEPTS[19]; // Corse-du-Sud
    } elseif ($code_dep == "20.2") {
        $nom_dept = $lignesDEPTS[20]; // Haute-Corse
    } else {
        $num = $code_dep;
        if ($num <= 19) {
            // De 1 à 19 on mets -1 car on commence a 0
            $nom_dept = $lignesDEPTS[$num - 1];
        } else {
            // Apres la corse qui est en double le dept = num
            $nom_dept = isset($lignesDEPTS[$num]) ? $lignesDEPTS[$num] : "Inconnu";
        }
    }
    // On ajoute le nom du département dans la deuxième colonne
    array_splice($nouvelle_ligne, 1, 0, trim($nom_dept));
    
    // On transforme le tableau pour qu'il soit enregistrable
    $tableau_depts[] = implode(",", $nouvelle_ligne);
}
// Enregistrement + trie
file_put_contents($fichier, implode("\n", $tableau_depts));
shell_exec("sort -t',' -k 3,3 -n -r \"$fichier\" -o \"$fichier\"");


$tableau_final = [];
$tableau_trie= file($fichier); // on le rouvre pour mettre les 2A et 2B de la corse
foreach ($tableau_trie as $ligne) {
    $ligne = rtrim($ligne);
    $cellules = explode(",", $ligne);
    
    // On remets les bons departements
    if ($cellules[2] == "20.1") {
        $cellules[2] = "2A";
    }
    if ($cellules[2] == "20.2") {
        $cellules[2] = "2B";
    }
    
    $tableau_final[] = implode(",",$cellules);
}

// Enregistrement final
file_put_contents($fichier, implode("\n", $tableau_final));
echo "✓ $fichier a été nettoyé.\n";
?>