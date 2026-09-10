<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="container" style="margin-bottom: 50px;">
    <h1 style="margin-bottom: 20px;"><i class="fa-solid fa-newspaper" style="color: var(--primary-color);"></i> <?= __('news') ?></h1>
    
    <div class="grid grid-2">
        <div class="card" style="grid-column: 1 / -1; background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8)), url('https://images.unsplash.com/photo-1546422904-90eab23c3d7e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80') center/cover; color: white;">
            <div class="card-body" style="padding: 60px 40px;">
                <span style="background-color: var(--primary-color); padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase;">Breaking</span>
                <h2 style="font-size: 32px; margin: 15px 0;">Tuniverse Platform Officially Launches in Tunisia</h2>
                <p style="font-size: 18px; opacity: 0.9; margin-bottom: 20px;">The all-in-one super app is now available, combining marketplace, food delivery, and more.</p>
                <button class="btn btn-primary">Read Full Story</button>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body">
                <h3 style="margin-bottom: 10px;">Tech Sector Growth in Tunis</h3>
                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 15px;">2 hours ago</p>
                <p>Startups are booming in the capital as new investments flow into the ecosystem...</p>
            </div>
        </div>
        
        <div class="card">
            <div class="card-body">
                <h3 style="margin-bottom: 10px;">New E-Dinar Integration</h3>
                <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 15px;">5 hours ago</p>
                <p>Digital payments made easier with the latest update to the national postal service...</p>
            </div>
        </div>
    </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
