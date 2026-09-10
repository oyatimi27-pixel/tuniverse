<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

// Auth Check & Role Check
if (!isset($_SESSION['user_id'])) {
    header("Location: ../auth/login.php");
    exit;
}

if ($_SESSION['role_id'] < 3) { // 3 = Business Owner
    die("Access Denied. Business Owner account required.");
}

$db = Database::getInstance();
$stmt = $db->prepare("SELECT * FROM businesses WHERE owner_id = ?");
$stmt->execute([$_SESSION['user_id']]);
$businesses = $stmt->fetchAll();

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container" style="margin-bottom: 50px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <h2>My Businesses</h2>
        <button class="btn btn-primary" onclick="alert('Feature to register a new business')"><i class="fa-solid fa-plus"></i> Add Business</button>
    </div>
    
    <?php if (empty($businesses)): ?>
        <div class="card text-center" style="padding: 60px 20px;">
            <i class="fa-solid fa-store" style="font-size: 60px; color: var(--border-color); margin-bottom: 20px;"></i>
            <h3>You don't have any businesses yet</h3>
            <p style="color: var(--text-muted); margin-top: 10px;">Register your business to start selling on Tuniverse.</p>
        </div>
    <?php else: ?>
        <div class="grid grid-3">
            <?php foreach ($businesses as $b): ?>
                <div class="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between; margin-bottom: 15px;">
                            <span style="background-color: var(--bg-color); color: var(--primary-color); padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase;">
                                <?= htmlspecialchars($b['type']) ?>
                            </span>
                            <span style="font-size: 12px; color: var(--success);"><i class="fa-solid fa-circle"></i> <?= htmlspecialchars($b['status']) ?></span>
                        </div>
                        <h3 style="font-size: 20px; margin-bottom: 10px;"><?= htmlspecialchars($b['name']) ?></h3>
                        <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 20px;"><?= htmlspecialchars($b['city'] ?? '') ?></p>
                        <a href="#" class="btn btn-outline btn-block" onclick="alert('Manage Dashboard for <?= htmlspecialchars($b['name']) ?>')">Manage Dashboard</a>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
