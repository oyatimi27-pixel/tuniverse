<?php
require_once __DIR__ . '/config/database.php';
$db = Database::getInstance();
$stmt = $db->query("DESCRIBE users");
print_r($stmt->fetchAll());
