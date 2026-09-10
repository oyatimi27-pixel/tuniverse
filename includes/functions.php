<?php
/**
 * Tuniverse - Translation Helper
 */

function __($key) {
    static $translations = null;
    
    if ($translations === null) {
        $lang = isset($_SESSION['lang']) ? $_SESSION['lang'] : 'en';
        
        $file = __DIR__ . '/../languages/' . $lang . '.php';
        
        if (file_exists($file)) {
            $translations = require $file;
        } else {
            // Fallback to English
            $translations = require __DIR__ . '/../languages/en.php';
        }
    }
    
    return isset($translations[$key]) ? $translations[$key] : $key;
}

function get_direction() {
    $lang = isset($_SESSION['lang']) ? $_SESSION['lang'] : 'en';
    return $lang === 'ar' ? 'rtl' : 'ltr';
}
