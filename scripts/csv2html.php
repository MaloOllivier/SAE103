<?php

$fichier = $argv[1];
$NOMFICH = $argv[2];

//lecture du fichier
$lignes = file($fichier);
$html = "<body>\n";
$html .= "<table border='1'; width: 100%;'>\n";

foreach ($lignes as $index => $ligne) {
    $cellules = explode(",", $ligne);
    $html .= "  <tr>\n";
    
    foreach ($cellules as $cellule) {
        if ($index === 0) {
            $html .= "    <th style='background-color: #d3d3d3ff; padding: 1em;'>" . htmlspecialchars($cellule) . "</th>\n";
        } else {
            $html .= "    <td style='padding: 1em;'>" . htmlspecialchars($cellule) . "</td>\n";
        }
    }
    $html .= "  </tr>\n";
}
$html .= "</table>\n";
$html .= "</body>";
// enregistrement en html
$FICH_HTML = "/data/" . $NOMFICH . ".html";
file_put_contents($FICH_HTML, $html);

echo "✓ Le tableau HTML a été généré dans $NOMFICH\n";
?>