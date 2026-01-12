<?php

$fichier = $argv[1];
$NOMFICH = $argv[2];

//lecture du fichier
$lignes = file($fichier);
$html = "
<head>
    <meta charset='UTF-8'>
    <style>
        @page {
            size: A4 landscape;
            margin: 0.5cm;
        }
        body{margin: 0;}
        table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }
        th, td{
            border: 1px solid black;
            padding: 3px;
            font-size: 8px;
            line-height: 0.9;
            word-wrap: break-word;
        }
        th{
          background-color: #ccc;
        }
        .Separation {
            column-count: 2;
            column-gap: 40px;
            column-rule: 1px solid #ccc;
            height: 21cm;
        }
    </style>
</head>

<body>\n";
$html .= "<div class=\"Separation\">";
$html .= "<table>\n";

foreach ($lignes as $index => $ligne) {
    $cellules = explode(",", $ligne);
    $html .= "  <tr>\n";
    
    foreach ($cellules as $cellule) {
        if ($index === 0) {
            $html .= "    <th>" . htmlspecialchars($cellule) . "</th>\n";
        } else {
            $html .= "    <td>" . htmlspecialchars($cellule) . "</td>\n";
        }
    }
    $html .= "  </tr>\n";
}
$html .= "</table>\n";
$html .= "</div>\n";
$html .= "</body>\n";
// enregistrement en html
$FICH_HTML = "/data/" . $NOMFICH . ".html";
file_put_contents($FICH_HTML, $html);

echo "✓ Le tableau HTML a été généré dans $NOMFICH\n";
?>