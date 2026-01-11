<?php
// Vérification que les arguments existent pour éviter les Warnings

$chemin_complet_csv = $argv[1]; // Ex: /data/salut copy.csv
$nom_fichier_sortie = $argv[2]; // Ex: salut copy

// 1. Lecture du fichier
if (!file_exists($chemin_complet_csv)) {
    die("Erreur : Le fichier $chemin_complet_csv est introuvable.\n");
}

$lignes = file($chemin_complet_csv);

$html = "<table border='1' style='border-collapse: collapse; width: 100%;'>\n";

foreach ($lignes as $index => $ligne) {
    $cellules = explode(",", $ligne);
    $html .= "  <tr>\n";
    
    foreach ($cellules as $cellule) {
        if ($index === 0) {
            $html .= "    <th style='background-color: #f2f2f2; padding: 8px;'>" . htmlspecialchars($cellule) . "</th>\n";
        } else {
            $html .= "    <td style='padding: 8px;'>" . htmlspecialchars($cellule) . "</td>\n";
        }
    }
    $html .= "  </tr>\n";
}
$html .= "</table>";

// 2. Enregistrement (On ajoute .html à la fin du nom passé en argument)
$nom_final_html = "/data/" . $nom_fichier_sortie . ".html";
file_put_contents($nom_final_html, $html);

echo "✓ Le tableau HTML a été généré dans $nom_final_html\n";
?>