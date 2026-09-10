<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="container" style="margin-bottom: 50px;">
    <div class="card text-center" style="padding: 80px 20px; background: linear-gradient(135deg, #2B2D42, #1a1c29); color: white;">
        <i class="fa-solid fa-car" style="font-size: 80px; margin-bottom: 20px; color: var(--primary-color);"></i>
        <h1 style="margin-bottom: 15px;"><?= __('transport') ?></h1>
        <p style="font-size: 18px; max-width: 600px; margin: 0 auto 30px; color: #ADB5BD;">Book a ride, find carpooling options, or rent a vehicle instantly through Tuniverse.</p>
        
        <div style="background: white; padding: 20px; border-radius: var(--border-radius-lg); max-width: 800px; margin: 0 auto; display: flex; gap: 15px; align-items: center; box-shadow: 0 10px 25px rgba(0,0,0,0.2);">
            <div style="flex: 1; text-align: left;">
                <label style="display: block; font-size: 12px; color: var(--text-muted); font-weight: bold; text-transform: uppercase; margin-bottom: 5px;">Pickup</label>
                <input type="text" placeholder="Current Location" style="width: 100%; border: none; font-size: 16px; font-weight: 500; outline: none; color: var(--text-main);">
            </div>
            <div style="width: 1px; height: 40px; background-color: var(--border-color);"></div>
            <div style="flex: 1; text-align: left;">
                <label style="display: block; font-size: 12px; color: var(--text-muted); font-weight: bold; text-transform: uppercase; margin-bottom: 5px;">Dropoff</label>
                <input type="text" placeholder="Where to?" style="width: 100%; border: none; font-size: 16px; font-weight: 500; outline: none; color: var(--text-main);">
            </div>
            <button class="btn btn-primary" style="padding: 15px 30px; font-size: 16px;" onclick="alert('Searching for available drivers...')">Request Ride</button>
        </div>
    </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
