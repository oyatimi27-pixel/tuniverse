<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="container" style="margin-bottom: 50px;">
    <div style="background-color: #E8F5E9; color: #1B5E20; padding: 50px 40px; border-radius: var(--border-radius-lg); text-align: center; margin-bottom: 40px;">
        <i class="fa-solid fa-briefcase" style="font-size: 60px; margin-bottom: 20px;"></i>
        <h1><?= __('jobs') ?></h1>
        <p style="font-size: 18px; max-width: 600px; margin: 0 auto;">Discover new career opportunities in Tunisia and apply directly.</p>
    </div>
    
    <div class="card">
        <div class="card-body">
            <h3 style="margin-bottom: 20px;">Latest Job Postings</h3>
            <div style="padding: 40px; text-align: center; color: var(--text-muted);">
                <i class="fa-solid fa-file-contract" style="font-size: 48px; margin-bottom: 15px; opacity: 0.5;"></i>
                <p>No job postings available at the moment. Please check back later.</p>
            </div>
        </div>
    </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
