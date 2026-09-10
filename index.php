<?php
require_once __DIR__ . '/includes/header.php';
?>

<div class="container">
    <section class="hero">
        <h1><?= __('app_name') ?></h1>
        <p><?= __('slogan') ?></p>
        <div style="display: flex; gap: 15px; justify-content: center;">
            <?php if(!isset($_SESSION['user_id'])): ?>
            <a href="<?= APP_URL ?>/modules/auth/register.php" class="btn btn-lg" style="background: white; color: black;">Get Started</a>
            <a href="<?= APP_URL ?>/modules/auth/login.php" class="btn btn-lg" style="background: rgba(255,255,255,0.1); color: white;">Login</a>
            <?php else: ?>
            <a href="<?= APP_URL ?>/modules/profile/index.php" class="btn btn-lg" style="background: white; color: black;">Go to Dashboard</a>
            <?php endif; ?>
        </div>
    </section>

    <h2 class="text-center mb-4">Explore Our Ecosystem</h2>
    
    <div class="bento-grid mb-5">
        <!-- Marketplace -->
        <a href="<?= APP_URL ?>/modules/marketplace/index.php" class="card bento-col-3 bento-row-4" style="display: flex; flex-direction: column; justify-content: center;">
            <div class="card-body text-center">
                <i class="fa-solid fa-shop" style="font-size: 48px; color: var(--primary-color); margin-bottom: 24px;"></i>
                <h3 style="font-size: 1.5rem; margin-bottom: 12px;"><?= __('marketplace') ?></h3>
                <p style="color: var(--text-muted);">Buy and sell products securely across Tunisia.</p>
            </div>
        </a>
        
        <!-- Transport -->
        <a href="<?= APP_URL ?>/modules/transport/index.php" class="card bento-col-6 bento-row-2" style="display: flex; align-items: center;">
            <div class="card-body" style="display: flex; align-items: center; gap: 24px; text-align: left;">
                <div style="background: #FEE2E2; padding: 20px; border-radius: 50%;">
                    <i class="fa-solid fa-car" style="font-size: 32px; color: var(--primary-color);"></i>
                </div>
                <div>
                    <h3 style="font-size: 1.5rem; margin-bottom: 8px;"><?= __('transport') ?></h3>
                    <p style="color: var(--text-muted); margin: 0;">Book rides and travel comfortably.</p>
                </div>
            </div>
        </a>
        
        <!-- Food -->
        <a href="<?= APP_URL ?>/modules/food/index.php" class="card bento-col-3 bento-row-2" style="display: flex; flex-direction: column; justify-content: center;">
            <div class="card-body text-center">
                <i class="fa-solid fa-burger" style="font-size: 32px; color: var(--primary-color); margin-bottom: 16px;"></i>
                <h3 style="font-size: 1.25rem; margin-bottom: 8px;"><?= __('food') ?></h3>
                <p style="color: var(--text-muted); margin: 0; font-size: 0.9rem;">Order from your favorite local restaurants.</p>
            </div>
        </a>
        
        <!-- Healthcare -->
        <a href="<?= APP_URL ?>/modules/healthcare/index.php" class="card card-dark bento-col-6 bento-row-2" style="display: flex; align-items: center;">
            <div class="card-body" style="display: flex; align-items: center; gap: 24px; text-align: left;">
                <div style="background: rgba(255,255,255,0.1); padding: 20px; border-radius: 50%;">
                    <i class="fa-solid fa-heart-pulse" style="font-size: 32px; color: white;"></i>
                </div>
                <div>
                    <h3 style="font-size: 1.5rem; margin-bottom: 8px; color: white;"><?= __('healthcare') ?></h3>
                    <p style="color: rgba(255,255,255,0.7); margin: 0;">Book appointments with top doctors.</p>
                </div>
            </div>
        </a>
        
        <!-- Education -->
        <a href="<?= APP_URL ?>/modules/education/index.php" class="card card-red bento-col-3 bento-row-2" style="display: flex; flex-direction: column; justify-content: center;">
            <div class="card-body text-center">
                <i class="fa-solid fa-graduation-cap" style="font-size: 32px; margin-bottom: 16px;"></i>
                <h3 style="font-size: 1.25rem; margin-bottom: 8px;"><?= __('education') ?></h3>
                <p style="margin: 0; font-size: 0.9rem; opacity: 0.8;">Find courses and educational resources.</p>
            </div>
        </a>
        
        <!-- Jobs -->
        <a href="<?= APP_URL ?>/modules/jobs/index.php" class="card bento-col-12 bento-row-2" style="display: flex; align-items: center; justify-content: space-between; background-image: linear-gradient(to right, #F4F4F7, #FFFFFF);">
            <div class="card-body" style="display: flex; align-items: center; gap: 32px; text-align: left; width: 100%;">
                <div style="background: white; padding: 24px; border-radius: 50%; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                    <i class="fa-solid fa-briefcase" style="font-size: 40px; color: var(--primary-color);"></i>
                </div>
                <div style="flex: 1;">
                    <h3 style="font-size: 2rem; margin-bottom: 8px;"><?= __('jobs') ?></h3>
                    <p style="color: var(--text-muted); margin: 0; font-size: 1.1rem;">Find your next career opportunity and grow professionally.</p>
                </div>
                <div style="padding-right: 24px;">
                    <span class="btn btn-primary" style="pointer-events: none;">Browse Jobs &rarr;</span>
                </div>
            </div>
        </a>
    </div>
</div>

<?php
require_once __DIR__ . '/includes/footer.php';
?>
