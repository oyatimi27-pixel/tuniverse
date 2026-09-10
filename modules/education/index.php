<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="container" style="margin-bottom: 50px;">
    <div style="background: linear-gradient(135deg, #1976D2, #0D47A1); color: white; padding: 50px 40px; border-radius: var(--border-radius-lg); text-align: center; margin-bottom: 40px;">
        <i class="fa-solid fa-graduation-cap" style="font-size: 60px; margin-bottom: 20px;"></i>
        <h1><?= __('education') ?></h1>
        <p style="font-size: 18px; opacity: 0.9;">Empower your future with top courses, tutors, and institutions.</p>
    </div>
    <div class="grid grid-3">
        <div class="card"><div class="card-body text-center"><i class="fa-solid fa-book-open" style="font-size: 40px; color: var(--primary-color); margin-bottom: 15px;"></i><h3>Online Courses</h3></div></div>
        <div class="card"><div class="card-body text-center"><i class="fa-solid fa-chalkboard-user" style="font-size: 40px; color: var(--primary-color); margin-bottom: 15px;"></i><h3>Find a Tutor</h3></div></div>
        <div class="card"><div class="card-body text-center"><i class="fa-solid fa-school" style="font-size: 40px; color: var(--primary-color); margin-bottom: 15px;"></i><h3>Universities</h3></div></div>
    </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
