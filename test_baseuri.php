<?php
// Mock server variables for XAMPP
$_SERVER['SCRIPT_FILENAME'] = 'C:\\xampp\\htdocs\\tuniverse\\modules\\auth\\login.php';
$_SERVER['SCRIPT_NAME'] = '/tuniverse/modules/auth/login.php';
// __DIR__ would be C:\xampp\htdocs\tuniverse (we'll just define $appRoot directly)
$appRoot = 'C:/xampp/htdocs/tuniverse';

$scriptPath = str_replace('\\', '/', $_SERVER['SCRIPT_FILENAME']);
if (strpos($scriptPath, $appRoot) === 0) {
    $relativePath = substr($scriptPath, strlen($appRoot));
    $scriptName = $_SERVER['SCRIPT_NAME'];
    if (substr($scriptName, -strlen($relativePath)) === $relativePath) {
        $baseUri = substr($scriptName, 0, -strlen($relativePath));
    } else {
        $baseUri = 'err1';
    }
} else {
    $baseUri = 'err2';
}
$baseUri = rtrim($baseUri, '/');
echo "Base URI 1: " . $baseUri . "\n";

// Mock server variables for AI Studio
$_SERVER['SCRIPT_FILENAME'] = '/app/applet/index.php';
$_SERVER['SCRIPT_NAME'] = '/index.php';
$appRoot = '/app/applet';

$scriptPath = str_replace('\\', '/', $_SERVER['SCRIPT_FILENAME']);
if (strpos($scriptPath, $appRoot) === 0) {
    $relativePath = substr($scriptPath, strlen($appRoot));
    $scriptName = $_SERVER['SCRIPT_NAME'];
    if (substr($scriptName, -strlen($relativePath)) === $relativePath) {
        $baseUri = substr($scriptName, 0, -strlen($relativePath));
    } else {
        $baseUri = 'err1';
    }
} else {
    $baseUri = 'err2';
}
$baseUri = rtrim($baseUri, '/');
echo "Base URI 2: " . $baseUri . "\n";
