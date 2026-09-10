<?php
$docRoot = rtrim(str_replace('\\', '/', $_SERVER['DOCUMENT_ROOT']), '/');
$dirRoot = rtrim(str_replace('\\', '/', __DIR__), '/');
$baseUri = '';
if (strpos($dirRoot, $docRoot) === 0) {
    $baseUri = substr($dirRoot, strlen($docRoot));
}
echo "docRoot: $docRoot\n";
echo "dirRoot: $dirRoot\n";
echo "baseUri: $baseUri\n";
