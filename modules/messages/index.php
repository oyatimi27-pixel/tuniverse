<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../includes/header.php';

// Auth Check
if (!isset($_SESSION['user_id'])) {
    header("Location: ../auth/login.php");
    exit;
}
?>
<div class="container" style="margin-bottom: 50px;">
    <div class="grid" style="grid-template-columns: 300px 1fr; gap: 0; background: var(--surface-color); border-radius: var(--border-radius-lg); box-shadow: var(--box-shadow); overflow: hidden;">
        
        <!-- Conversations List -->
        <div style="border-right: 1px solid var(--border-color); background-color: var(--bg-color);">
            <div style="padding: 20px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                <h3 style="margin: 0;"><?= __('messages') ?></h3>
                <button class="btn btn-outline" style="padding: 5px 10px; font-size: 12px;"><i class="fa-solid fa-pen-to-square"></i></button>
            </div>
            
            <div style="overflow-y: auto; height: 500px;">
                <div style="padding: 15px 20px; border-bottom: 1px solid var(--border-color); background-color: white; border-left: 3px solid var(--primary-color); cursor: pointer;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span style="font-weight: 600;">Support Team</span>
                        <span style="font-size: 12px; color: var(--text-muted);">10:30 AM</span>
                    </div>
                    <p style="font-size: 13px; color: var(--text-muted); margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Welcome to Tuniverse! How can we help you today?</p>
                </div>
                
                <div style="padding: 15px 20px; border-bottom: 1px solid var(--border-color); cursor: pointer;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
                        <span style="font-weight: 600;">Restaurant Pasta Cosi</span>
                        <span style="font-size: 12px; color: var(--text-muted);">Yesterday</span>
                    </div>
                    <p style="font-size: 13px; color: var(--text-muted); margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Your order is on the way!</p>
                </div>
            </div>
        </div>
        
        <!-- Chat Area -->
        <div style="display: flex; flex-direction: column; height: 580px;">
            <div style="padding: 20px; border-bottom: 1px solid var(--border-color); background-color: white;">
                <h4 style="margin: 0;">Support Team</h4>
                <span style="font-size: 12px; color: var(--success);"><i class="fa-solid fa-circle" style="font-size: 8px;"></i> Online</span>
            </div>
            
            <div style="flex: 1; padding: 20px; overflow-y: auto; background-color: #F8F9FA;">
                <!-- Received Msg -->
                <div style="margin-bottom: 15px; max-width: 70%;">
                    <div style="background-color: white; padding: 10px 15px; border-radius: 15px; border-top-left-radius: 0; box-shadow: 0 1px 2px rgba(0,0,0,0.05); display: inline-block;">
                        Welcome to Tuniverse! How can we help you today?
                    </div>
                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 5px;">10:30 AM</div>
                </div>
            </div>
            
            <div style="padding: 20px; border-top: 1px solid var(--border-color); background-color: white;">
                <form style="display: flex; gap: 10px;" onsubmit="event.preventDefault();">
                    <input type="text" class="form-control" placeholder="Type a message..." style="border-radius: 20px;">
                    <button type="submit" class="btn btn-primary" style="border-radius: 50%; width: 45px; height: 45px; padding: 0;"><i class="fa-solid fa-paper-plane"></i></button>
                </form>
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

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
