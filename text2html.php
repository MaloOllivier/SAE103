#!/bin/php
<?php 
$fichier = $argv[1];

$lignes = file($fichier);

$tab_html = [];
foreach ($lignes as $i => $ligne) {
    if($i == 0) {
        // On mets la première ligne en <h1>
        $tab_html[] = '<h1>' . $ligne . '</h1>';
    } else {
        $ligne = rtrim($ligne);
        // On mets les autres lignes en <p>
        $tab_html[] = $ligne = '<p>' . $ligne . '</p>';
    }
}

file_put_contents("$fichier", implode("\n", $tab_html));
?>