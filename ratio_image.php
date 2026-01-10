<?php

$width = $argv[1];
$height = $argv[2];

$maxWidth = 900;
$maxHeight = 620;

$ratio = min($maxWidth/$width, $maxHeight/$height);

$newWidth = (int)($width * $ratio);
$newHeight = (int)($height * $ratio);

echo "$newWidth $newHeight";
