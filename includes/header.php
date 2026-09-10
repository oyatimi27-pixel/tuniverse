<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/functions.php';

$dir = get_direction();
$lang = isset($_SESSION['lang']) ? $_SESSION['lang'] : 'en';

// Handle Language Switch
if (isset($_GET['lang']) && in_array($_GET['lang'], ['en', 'fr', 'ar'])) {
    $_SESSION['lang'] = $_GET['lang'];
    header("Location: " . strtok($_SERVER["REQUEST_URI"], '?'));
    exit;
}
?>
<!DOCTYPE html>
<html lang="<?= $lang ?>" dir="<?= $dir ?>">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= __('app_name') ?> | <?= __('slogan') ?></title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="<?= APP_URL ?>/assets/css/style.css">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <?php if ($lang === 'ar'): ?>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700&display=swap" rel="stylesheet">
    <?php else: ?>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <?php endif; ?>
    
    <!-- Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="<?= $dir ?>">
    <nav class="navbar">
        <div class="container nav-container">
            <a href="<?= APP_URL ?>/index.php" class="logo">
                <i class="fa-solid fa-infinity"></i> <?= __('app_name') ?>
            </a>
            
            <div class="nav-links">
                <a href="<?= APP_URL ?>/index.php"><?= __('home') ?></a>
                
                <!-- Modules Dropdown -->
                <div class="dropdown">
                    <button class="dropbtn"><?= __('services') ?> <i class="fa-solid fa-caret-down"></i></button>
                    <div class="dropdown-content">
                        <a href="<?= APP_URL ?>/modules/marketplace/index.php"><i class="fa-solid fa-shop"></i> <?= __('marketplace') ?></a>
                        <a href="<?= APP_URL ?>/modules/food/index.php"><i class="fa-solid fa-burger"></i> <?= __('food') ?></a>
                        <a href="<?= APP_URL ?>/modules/transport/index.php"><i class="fa-solid fa-car"></i> <?= __('transport') ?></a>
                        <a href="<?= APP_URL ?>/modules/healthcare/index.php"><i class="fa-solid fa-heart-pulse"></i> <?= __('healthcare') ?></a>
                        <a href="<?= APP_URL ?>/modules/education/index.php"><i class="fa-solid fa-graduation-cap"></i> <?= __('education') ?></a>
                        <a href="<?= APP_URL ?>/modules/jobs/index.php"><i class="fa-solid fa-briefcase"></i> <?= __('jobs') ?></a>
                        <a href="<?= APP_URL ?>/modules/news/index.php"><i class="fa-solid fa-newspaper"></i> <?= __('news') ?></a>
                    </div>
                </div>
            </div>
            
            <div class="nav-actions">
                <!-- Language Switcher -->
                <div class="dropdown lang-dropdown">
                    <button class="dropbtn"><i class="fa-solid fa-globe"></i> <?= strtoupper($lang) ?></button>
                    <div class="dropdown-content">
                        <a href="?lang=en">English</a>
                        <a href="?lang=fr">Français</a>
                        <a href="?lang=ar">العربية</a>
                    </div>
                </div>
                
                <?php if (isset($_SESSION['user_id'])): ?>
                    <a href="<?= APP_URL ?>/modules/wallet/index.php" class="btn btn-outline"><i class="fa-solid fa-wallet"></i> <?= __('wallet') ?></a>
                    <div class="dropdown">
                        <button class="dropbtn btn btn-primary"><i class="fa-solid fa-user"></i> <?= __('profile') ?></button>
                        <div class="dropdown-content">
                            <a href="<?= APP_URL ?>/modules/profile/index.php"><i class="fa-solid fa-id-card"></i> <?= __('dashboard') ?></a>
                            <a href="<?= APP_URL ?>/modules/messages/index.php"><i class="fa-solid fa-envelope"></i> <?= __('messages') ?></a>
                            <a href="<?= APP_URL ?>/modules/auth/logout.php"><i class="fa-solid fa-right-from-bracket"></i> <?= __('logout') ?></a>
                        </div>
                    </div>
                <?php else: ?>
                    <a href="<?= APP_URL ?>/modules/auth/login.php" class="btn btn-outline"><?= __('login') ?></a>
                    <a href="<?= APP_URL ?>/modules/auth/register.php" class="btn btn-primary"><?= __('register') ?></a>
                <?php endif; ?>
                
                <!-- Mobile Menu Toggle -->
                <button class="mobile-menu-btn" id="mobileMenuBtn">
                    <i class="fa-solid fa-bars"></i>
                </button>
            </div>
        </div>
    </nav>
    <main class="main-content">
