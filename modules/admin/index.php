<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

// Auth Check & Role Check
if (!isset($_SESSION['user_id'])) {
    header("Location: ../auth/login.php");
    exit;
}

if ($_SESSION['role_id'] < 5) { // 5 = Admin, 6 = Super Admin
    die("Access Denied. Administrator privileges required.");
}

$db = Database::getInstance();
$stats = [
    'users' => $db->query("SELECT COUNT(*) FROM users")->fetchColumn(),
    'businesses' => $db->query("SELECT COUNT(*) FROM businesses")->fetchColumn(),
    'orders' => $db->query("SELECT COUNT(*) FROM orders")->fetchColumn(),
    'transactions' => $db->query("SELECT COUNT(*) FROM transactions")->fetchColumn()
];

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container" style="margin-bottom: 50px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <h2><i class="fa-solid fa-shield-halved" style="color: var(--primary-color);"></i> Admin Dashboard</h2>
    </div>
    
    <div class="grid grid-4" style="margin-bottom: 30px;">
        <div class="card" style="border-left: 4px solid var(--primary-color);">
            <div class="card-body">
                <div style="color: var(--text-muted); font-size: 14px; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Total Users</div>
                <div style="font-size: 28px; font-weight: bold;"><?= number_format($stats['users']) ?></div>
            </div>
        </div>
        <div class="card" style="border-left: 4px solid var(--success);">
            <div class="card-body">
                <div style="color: var(--text-muted); font-size: 14px; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Businesses</div>
                <div style="font-size: 28px; font-weight: bold;"><?= number_format($stats['businesses']) ?></div>
            </div>
        </div>
        <div class="card" style="border-left: 4px solid var(--warning);">
            <div class="card-body">
                <div style="color: var(--text-muted); font-size: 14px; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Total Orders</div>
                <div style="font-size: 28px; font-weight: bold;"><?= number_format($stats['orders']) ?></div>
            </div>
        </div>
        <div class="card" style="border-left: 4px solid var(--accent-color);">
            <div class="card-body">
                <div style="color: var(--text-muted); font-size: 14px; text-transform: uppercase; font-weight: bold; margin-bottom: 5px;">Transactions</div>
                <div style="font-size: 28px; font-weight: bold;"><?= number_format($stats['transactions']) ?></div>
            </div>
        </div>
    </div>
    
    <div class="grid" style="grid-template-columns: 250px 1fr; gap: 30px;">
        <div class="card">
            <div class="card-body" style="padding: 15px 0;">
                <a href="#" style="display: block; padding: 10px 20px; color: var(--primary-color); background-color: var(--bg-color); font-weight: 500; border-left: 3px solid var(--primary-color);"><i class="fa-solid fa-chart-pie" style="width: 25px;"></i> Overview</a>
                <a href="#" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-users" style="width: 25px;"></i> Manage Users</a>
                <a href="#" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-store" style="width: 25px;"></i> Businesses</a>
                <a href="#" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-flag" style="width: 25px;"></i> Reports</a>
                <a href="#" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-gear" style="width: 25px;"></i> Settings</a>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body text-center" style="padding: 60px 20px;">
                <i class="fa-solid fa-screwdriver-wrench" style="font-size: 48px; color: var(--border-color); margin-bottom: 15px;"></i>
                <h3>Admin controls are centralized here</h3>
                <p style="color: var(--text-muted); margin-top: 10px;">Select an option from the sidebar to manage platform entities.</p>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
