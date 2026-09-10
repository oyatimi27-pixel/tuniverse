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

// Fetch Wallet
$wallet_stmt = $db->prepare("SELECT id, balance, currency FROM wallets WHERE user_id = ?");
$wallet_stmt->execute([$_SESSION['user_id']]);
$wallet = $wallet_stmt->fetch();

// Fetch Transactions
$trans_stmt = $db->prepare("SELECT * FROM transactions WHERE wallet_id = ? ORDER BY created_at DESC LIMIT 50");
$trans_stmt->execute([$wallet['id']]);
$transactions = $trans_stmt->fetchAll();

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container" style="margin-bottom: 40px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
        <h2><?= __('wallet') ?> Dashboard</h2>
        <a href="../profile/index.php" class="btn btn-outline">Back to Profile</a>
    </div>
    
    <div class="grid grid-3" style="margin-bottom: 30px;">
        <div class="card" style="background-color: var(--primary-color); color: white;">
            <div class="card-body text-center">
                <p style="font-size: 16px; margin-bottom: 10px; opacity: 0.9;">Available Balance</p>
                <h3 style="font-size: 36px; margin-bottom: 10px;"><?= number_format($wallet['balance'], 3) ?> <span style="font-size: 18px;"><?= htmlspecialchars($wallet['currency']) ?></span></h3>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body text-center" style="display: flex; flex-direction: column; justify-content: center; height: 100%;">
                <button class="btn btn-primary btn-block mb-4" onclick="alert('Deposit functionality would integrate with local payment gateways (e.g. ClicToPay, D17, RunPay).')"><i class="fa-solid fa-plus"></i> Deposit Funds</button>
                <button class="btn btn-outline btn-block" onclick="alert('Withdraw functionality would connect to bank accounts or postal accounts (eDinar).')"><i class="fa-solid fa-arrow-right-arrow-left"></i> Withdraw Funds</button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body">
                <h4 style="margin-bottom: 15px;">Quick Transfer</h4>
                <form onsubmit="event.preventDefault(); alert('Transfer initiated!');">
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="Recipient Email or Phone" required>
                    </div>
                    <div class="form-group" style="display: flex; gap: 10px;">
                        <input type="number" step="0.001" class="form-control" placeholder="Amount" required>
                        <button type="submit" class="btn btn-primary">Send</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="card">
        <div class="card-body">
            <h3 style="margin-bottom: 20px;">Transaction History</h3>
            
            <?php if (empty($transactions)): ?>
                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                    <i class="fa-solid fa-receipt" style="font-size: 48px; margin-bottom: 15px; opacity: 0.5;"></i>
                    <p>No transactions found.</p>
                </div>
            <?php else: ?>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; text-align: left;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--border-color);">
                                <th style="padding: 15px 10px; color: var(--text-muted);">Date</th>
                                <th style="padding: 15px 10px; color: var(--text-muted);">Type</th>
                                <th style="padding: 15px 10px; color: var(--text-muted);">Description</th>
                                <th style="padding: 15px 10px; color: var(--text-muted);">Reference</th>
                                <th style="padding: 15px 10px; color: var(--text-muted);">Status</th>
                                <th style="padding: 15px 10px; color: var(--text-muted); text-align: right;">Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($transactions as $t): ?>
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 15px 10px;"><?= date('M d, Y H:i', strtotime($t['created_at'])) ?></td>
                                <td style="padding: 15px 10px; text-transform: capitalize; font-weight: 500;">
                                    <?php
                                    $icon = '';
                                    if ($t['type'] == 'deposit') $icon = '<i class="fa-solid fa-arrow-down" style="color: var(--success);"></i> ';
                                    elseif ($t['type'] == 'withdrawal') $icon = '<i class="fa-solid fa-arrow-up" style="color: var(--danger);"></i> ';
                                    else $icon = '<i class="fa-solid fa-exchange-alt" style="color: var(--accent-color);"></i> ';
                                    echo $icon . htmlspecialchars($t['type']);
                                    ?>
                                </td>
                                <td style="padding: 15px 10px;"><?= htmlspecialchars($t['description'] ?? 'N/A') ?></td>
                                <td style="padding: 15px 10px; font-family: monospace; font-size: 13px;"><?= htmlspecialchars($t['reference'] ?? '-') ?></td>
                                <td style="padding: 15px 10px;">
                                    <?php
                                    $color = 'var(--text-muted)';
                                    if ($t['status'] == 'completed') $color = 'var(--success)';
                                    elseif ($t['status'] == 'failed') $color = 'var(--danger)';
                                    elseif ($t['status'] == 'pending') $color = 'var(--warning)';
                                    ?>
                                    <span style="background-color: <?= $color ?>; color: white; padding: 3px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; text-transform: capitalize;">
                                        <?= htmlspecialchars($t['status']) ?>
                                    </span>
                                </td>
                                <td style="padding: 15px 10px; text-align: right; font-weight: 600; color: <?= in_array($t['type'], ['withdrawal', 'payment']) ? 'var(--danger)' : 'var(--success)' ?>;">
                                    <?= in_array($t['type'], ['withdrawal', 'payment']) ? '-' : '+' ?><?= number_format($t['amount'], 3) ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            <?php endif; ?>
        </div>
    </div>
</div>

<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
