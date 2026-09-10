<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

// Auth Check
if (!isset($_SESSION['user_id'])) {
    header("Location: ../auth/login.php");
    exit;
}

$db = Database::getInstance();
$stmt = $db->prepare("SELECT * FROM users WHERE id = ?");
$stmt->execute([$_SESSION['user_id']]);
$user = $stmt->fetch();

if (!$user) {
    session_destroy();
    header("Location: ../auth/login.php");
    exit;
}

// Fetch Wallet Balance
$wallet_stmt = $db->prepare("SELECT balance, currency FROM wallets WHERE user_id = ?");
$wallet_stmt->execute([$user['id']]);
$wallet = $wallet_stmt->fetch();

$success = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['update_profile'])) {
    $first_name = trim(htmlspecialchars($_POST['first_name']));
    $last_name = trim(htmlspecialchars($_POST['last_name']));
    $phone = trim(htmlspecialchars($_POST['phone']));
    $bio = trim(htmlspecialchars($_POST['bio']));
    
    if ($first_name && $last_name) {
        $update_stmt = $db->prepare("UPDATE users SET first_name = ?, last_name = ?, phone = ?, bio = ? WHERE id = ?");
        if ($update_stmt->execute([$first_name, $last_name, $phone, $bio, $user['id']])) {
            $success = "Profile updated successfully.";
            // Update session name
            $_SESSION['user_name'] = $first_name . ' ' . $last_name;
            // Refresh user data
            $stmt->execute([$user['id']]);
            $user = $stmt->fetch();
        } else {
            $error = "Failed to update profile.";
        }
    } else {
        $error = "First name and last name are required.";
    }
}

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container">
    <div class="grid" style="grid-template-columns: 250px 1fr; gap: 30px; margin-bottom: 40px;">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="card" style="margin-bottom: 20px;">
                <div class="card-body text-center">
                    <img src="<?= APP_URL ?>/assets/img/<?= htmlspecialchars($user['profile_picture']) ?>" alt="Profile" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; margin-bottom: 15px; border: 3px solid var(--border-color);" onerror="this.src='https://ui-avatars.com/api/?name=<?= urlencode($user['first_name'].' '.$user['last_name']) ?>&background=random'">
                    <h3 style="font-size: 18px;"><?= htmlspecialchars($user['first_name'] . ' ' . $user['last_name']) ?></h3>
                    <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 15px;"><?= htmlspecialchars($user['email']) ?></p>
                    
                    <div style="background-color: var(--bg-color); padding: 10px; border-radius: var(--border-radius); display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-size: 14px; font-weight: 500;">Wallet</span>
                        <span style="font-weight: 700; color: var(--primary-color);"><?= number_format($wallet['balance'], 3) ?> <?= $wallet['currency'] ?></span>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-body" style="padding: 15px 0;">
                    <a href="index.php" style="display: block; padding: 10px 20px; color: var(--primary-color); background-color: var(--bg-color); font-weight: 500; border-left: 3px solid var(--primary-color);"><i class="fa-solid fa-user" style="width: 25px;"></i> Edit Profile</a>
                    <a href="../wallet/index.php" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-wallet" style="width: 25px;"></i> My Wallet</a>
                    <a href="../messages/index.php" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-envelope" style="width: 25px;"></i> Messages</a>
                    <?php if ($user['role_id'] >= 3): ?>
                    <a href="../business/index.php" style="display: block; padding: 10px 20px; color: var(--text-main);"><i class="fa-solid fa-store" style="width: 25px;"></i> My Businesses</a>
                    <?php endif; ?>
                    <hr style="border: 0; border-top: 1px solid var(--border-color); margin: 10px 0;">
                    <a href="../auth/logout.php" style="display: block; padding: 10px 20px; color: var(--danger);"><i class="fa-solid fa-right-from-bracket" style="width: 25px;"></i> Logout</a>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="profile-content">
            <div class="card">
                <div class="card-body">
                    <h2 class="mb-4">Profile Settings</h2>
                    
                    <?php if ($success): ?>
                        <div style="background-color: var(--success); color: white; padding: 10px; border-radius: var(--border-radius); margin-bottom: 20px;">
                            <?= htmlspecialchars($success) ?>
                        </div>
                    <?php endif; ?>
                    
                    <?php if ($error): ?>
                        <div style="background-color: var(--danger); color: white; padding: 10px; border-radius: var(--border-radius); margin-bottom: 20px;">
                            <?= htmlspecialchars($error) ?>
                        </div>
                    <?php endif; ?>
                    
                    <form method="POST" action="">
                        <input type="hidden" name="update_profile" value="1">
                        <div class="grid grid-2">
                            <div class="form-group">
                                <label for="first_name"><?= __('first_name') ?></label>
                                <input type="text" id="first_name" name="first_name" class="form-control" value="<?= htmlspecialchars($user['first_name']) ?>" required>
                            </div>
                            <div class="form-group">
                                <label for="last_name"><?= __('last_name') ?></label>
                                <input type="text" id="last_name" name="last_name" class="form-control" value="<?= htmlspecialchars($user['last_name']) ?>" required>
                            </div>
                        </div>
                        
                        <div class="grid grid-2">
                            <div class="form-group">
                                <label for="email"><?= __('email') ?> (Read Only)</label>
                                <input type="email" id="email" class="form-control" value="<?= htmlspecialchars($user['email']) ?>" readonly style="background-color: var(--bg-color);">
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" id="phone" name="phone" class="form-control" value="<?= htmlspecialchars($user['phone'] ?? '') ?>">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="bio">Biography</label>
                            <textarea id="bio" name="bio" class="form-control" rows="4"><?= htmlspecialchars($user['bio'] ?? '') ?></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary"><?= __('save') ?> Changes</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
@media (max-width: 768px) {
    .container > .grid {
        grid-template-columns: 1fr !important;
    }
}
</style>

<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
