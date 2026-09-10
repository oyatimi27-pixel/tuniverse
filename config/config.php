<?php
/**
 * Tuniverse - Configuration
 */

session_start();

// Database Configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'tuniverse');
define('DB_USER', 'root');
define('DB_PASS', '');

// Application Settings
define('APP_NAME', 'Tuniverse');

// Dynamically determine APP_URL for XAMPP or Preview environments
$scriptPath = str_replace('\\', '/', $_SERVER['SCRIPT_FILENAME']);
$appRoot = str_replace('\\', '/', dirname(__DIR__));
$baseUri = '';

if (stripos($scriptPath, $appRoot) === 0) {
    $relativePath = substr($scriptPath, strlen($appRoot));
    $scriptName = $_SERVER['SCRIPT_NAME'];
    $len = strlen($relativePath);
    
    if ($len > 0) {
        if (strcasecmp(substr($scriptName, -$len), $relativePath) === 0) {
            $baseUri = substr($scriptName, 0, -$len);
        }
    } else {
        $baseUri = $scriptName;
    }
} else {
    // Fallback for symlinks or unusual server setups
    $docRoot = rtrim(str_replace('\\', '/', $_SERVER['DOCUMENT_ROOT']), '/');
    if (stripos($appRoot, $docRoot) === 0) {
        $baseUri = substr($appRoot, strlen($docRoot));
    }
}

$baseUri = rtrim($baseUri, '/');
define('APP_URL', $baseUri);

// Default Language
if (!isset($_SESSION['lang'])) {
    $_SESSION['lang'] = 'en'; // default to english
}

// Set error reporting for development (disable in production)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
