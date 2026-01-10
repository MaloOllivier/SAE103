#!/bin/php
<?php 
$fichier = $argv[1];

$lignes = file($fichier);

$tab_html = [];
foreach ($lignes as $ligne) {
    $ligne = rtrim($ligne);
    // On remets les guillemets au debut et a la fin de la premiere case (nom du site)
    $ligne = '<p>' . $ligne . '<\p>';
    // On fusionne les cellules en les séparant par des virgules
    $tab_html[] = $ligne;
}

file_put_contents($fichier, implode("\n", $tab_html));
?>