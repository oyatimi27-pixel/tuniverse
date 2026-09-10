<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

if (isset($_SESSION['user_id'])) {
    header("Location: ../profile/index.php");
    exit;
}

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $first_name = trim(htmlspecialchars($_POST['first_name'] ?? ''));
    $last_name = trim(htmlspecialchars($_POST['last_name'] ?? ''));
    $email = filter_var($_POST['email'] ?? '', FILTER_SANITIZE_EMAIL);
    $password = $_POST['password'] ?? '';
    $password_confirm = $_POST['password_confirm'] ?? '';
    
    if ($first_name && $last_name && $email && $password && $password_confirm) {
        if ($password !== $password_confirm) {
            $error = "Passwords do not match.";
        } elseif (strlen($password) < 8) {
            $error = "Password must be at least 8 characters long.";
        } else {
            $db = Database::getInstance();
            // Check if email exists
            $stmt = $db->prepare("SELECT id FROM users WHERE email = ? LIMIT 1");
            $stmt->execute([$email]);
            if ($stmt->fetch()) {
                $error = "Email is already registered.";
            } else {
                // Register user
                $hash = password_hash($password, PASSWORD_DEFAULT);
                $stmt = $db->prepare("INSERT INTO users (first_name, last_name, email, password_hash) VALUES (?, ?, ?, ?)");
                
                try {
                    $stmt->execute([$first_name, $last_name, $email, $hash]);
                    $new_user_id = $db->lastInsertId();
                    
                    // Create an empty wallet for the user
                    $wallet_stmt = $db->prepare("INSERT INTO wallets (user_id) VALUES (?)");
                    $wallet_stmt->execute([$new_user_id]);
                    
                    $success = "Account created successfully. You can now login.";
                } catch (\PDOException $e) {
                    $error = "Registration failed. Please try again later.";
                }
            }
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
            <h2 class="text-center mb-4"><?= __('register') ?></h2>
            
            <?php if ($error): ?>
                <div style="background-color: var(--danger); color: white; padding: 10px; border-radius: var(--border-radius); margin-bottom: 20px;">
                    <?= htmlspecialchars($error) ?>
                </div>
            <?php endif; ?>
            
            <?php if ($success): ?>
                <div style="background-color: var(--success); color: white; padding: 10px; border-radius: var(--border-radius); margin-bottom: 20px;">
                    <?= htmlspecialchars($success) ?>
                </div>
                <div class="text-center">
                    <a href="login.php" class="btn btn-primary"><?= __('login') ?></a>
                </div>
            <?php else: ?>
                <form method="POST" action="">
                    <div class="grid grid-2" style="gap: 15px;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label for="first_name"><?= __('first_name') ?></label>
                            <input type="text" id="first_name" name="first_name" class="form-control" required value="<?= htmlspecialchars($_POST['first_name'] ?? '') ?>">
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <label for="last_name"><?= __('last_name') ?></label>
                            <input type="text" id="last_name" name="last_name" class="form-control" required value="<?= htmlspecialchars($_POST['last_name'] ?? '') ?>">
                        </div>
                    </div>
                    
                    <div class="form-group mt-4">
                        <label for="email"><?= __('email') ?></label>
                        <input type="email" id="email" name="email" class="form-control" required value="<?= htmlspecialchars($_POST['email'] ?? '') ?>">
                    </div>
                    
                    <div class="form-group">
                        <label for="password"><?= __('password') ?></label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password_confirm">Confirm Password</label>
                        <input type="password" id="password_confirm" name="password_confirm" class="form-control" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block mt-4"><?= __('register') ?></button>
                </form>
                
                <div class="text-center mt-4">
                    <p><?= __('already_have_account') ?> <a href="login.php"><?= __('login') ?></a></p>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
