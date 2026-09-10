<?php
$_SERVER['SCRIPT_FILENAME'] = 'c:\\xampp\\htdocs\\tuniverse\\modules\\auth\\login.php';
$_SERVER['SCRIPT_NAME'] = '/Tuniverse/modules/auth/login.php';
$appRoot = 'C:/xampp/htdocs/tuniverse';

$scriptPath = str_replace('\\', '/', $_SERVER['SCRIPT_FILENAME']);
if (stripos($scriptPath, $appRoot) === 0) {
    $relativePath = substr($scriptPath, strlen($appRoot));
    $scriptName = $_SERVER['SCRIPT_NAME'];
    $len = strlen($relativePath);
    if ($len > 0) {
        if (strcasecmp(substr($scriptName, -$len), $relativePath) === 0) {
            $baseUri = substr($scriptName, 0, -$len);
        } else {
            $baseUri = 'err1';
        }
    } else {
        $baseUri = $scriptName;
    }
} else {
    $baseUri = 'err2';
}
$baseUri = rtrim($baseUri, '/');
echo "Base URI Windows: " . $baseUri . "\n";
