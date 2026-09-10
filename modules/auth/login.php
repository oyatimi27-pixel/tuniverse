<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

// Redirect if already logged in
if (isset($_SESSION['user_id'])) {
    header("Location: ../profile/index.php");
    exit;
}

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = filter_var($_POST['email'] ?? '', FILTER_SANITIZE_EMAIL);
    $password = $_POST['password'] ?? '';
    
    if ($email && $password) {
        $db = Database::getInstance();
        $stmt = $db->prepare("SELECT id, password_hash, role_id, first_name, last_name, status FROM users WHERE email = ? LIMIT 1");
        $stmt->execute([$email]);
        $user = $stmt->fetch();
        
        if ($user && password_verify($password, $user['password_hash'])) {
            $userStatus = $user['status'] ?? 'active';
            if ($userStatus !== 'active') {
                $error = "Your account is currently " . htmlspecialchars($userStatus);
            } else {
                // Set session
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['role_id'] = $user['role_id'];
                $_SESSION['user_name'] = $user['first_name'] . ' ' . $user['last_name'];
                
                header("Location: ../profile/index.php");
                exit;
            }
        } else {
            $error = "Invalid email or password.";
        }
    } else {
        $error = "Please fill in all fields.";
    }
}

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container" style="max-width: 500px; padding: 40px 20px;">
    <div class="card">
        <div class="card-body">
            <h2 class="text-center mb-4"><?= __('login') ?></h2>
            
            <?php if ($error): ?>
                <div style="background-color: var(--danger); color: white; padding: 10px; border-radius: var(--border-radius); margin-bottom: 20px;">
                    <?= htmlspecialchars($error) ?>
                </div>
            <?php endif; ?>
            
            <form method="POST" action="">
                <div class="form-group">
                    <label for="email"><?= __('email') ?></label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="password"><?= __('password') ?></label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <label style="display: flex; align-items: center; gap: 5px; font-weight: normal; font-size: 14px;">
                        <input type="checkbox" name="remember"> <?= __('remember_me') ?>
                    </label>
                    <a href="forgot.php" style="font-size: 14px;"><?= __('forgot_password') ?></a>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block"><?= __('login') ?></button>
            </form>
            
            <div class="text-center mt-4">
                <p><?= __('dont_have_account') ?> <a href="register.php"><?= __('register') ?></a></p>
            </div>
        </div>
    </div>
</div>

<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
