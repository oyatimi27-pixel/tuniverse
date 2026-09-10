<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../includes/header.php';
?>
<div class="container" style="margin-bottom: 50px;">
    <div style="background-color: #E3F2FD; color: #0D47A1; padding: 50px 40px; border-radius: var(--border-radius-lg); margin-bottom: 40px; text-align: center;">
        <i class="fa-solid fa-user-doctor" style="font-size: 60px; margin-bottom: 20px;"></i>
        <h1 style="font-size: 36px; margin-bottom: 10px;"><?= __('healthcare') ?></h1>
        <p style="font-size: 18px; max-width: 600px; margin: 0 auto 30px;">Find top doctors, clinics, and pharmacies near you. Book appointments instantly.</p>
        
        <form style="display: flex; gap: 10px; max-width: 600px; margin: 0 auto;">
            <input type="text" class="form-control" placeholder="Search by specialty, doctor name, or clinic..." style="padding: 15px; border: none; box-shadow: var(--box-shadow);">
            <button class="btn btn-primary" style="padding: 0 30px;"><i class="fa-solid fa-search"></i></button>
        </form>
    </div>
    
    <div class="grid grid-4">
        <?php
        $specialties = [
            ['name' => 'General Practice', 'icon' => 'fa-stethoscope'],
            ['name' => 'Dentistry', 'icon' => 'fa-tooth'],
            ['name' => 'Cardiology', 'icon' => 'fa-heart-pulse'],
            ['name' => 'Pediatrics', 'icon' => 'fa-baby'],
            ['name' => 'Neurology', 'icon' => 'fa-brain'],
            ['name' => 'Orthopedics', 'icon' => 'fa-bone'],
            ['name' => 'Ophthalmology', 'icon' => 'fa-eye'],
            ['name' => 'Pharmacies', 'icon' => 'fa-pills']
        ];
        
        foreach ($specialties as $spec):
        ?>
        <div class="card text-center" style="cursor: pointer;" onclick="alert('Viewing doctors in <?= $spec['name'] ?>')">
            <div class="card-body">
                <div style="width: 60px; height: 60px; background-color: #E3F2FD; color: #0D47A1; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; font-size: 24px;">
                    <i class="fa-solid <?= $spec['icon'] ?>"></i>
                </div>
                <h3 style="font-size: 16px;"><?= $spec['name'] ?></h3>
            </div>
        </div>
        <?php endforeach; ?>
    </div>
</div>
<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
