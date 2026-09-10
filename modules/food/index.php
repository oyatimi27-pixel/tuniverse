<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

$db = Database::getInstance();

// Auto-seed Restaurants if empty (For demo purposes)
$check = $db->query("SELECT COUNT(*) FROM businesses WHERE type = 'restaurant'")->fetchColumn();
if ($check == 0) {
    // We need a dummy user to own these businesses
    $dummy_user = $db->query("SELECT id FROM users LIMIT 1")->fetchColumn();
    if ($dummy_user) {
        $db->query("INSERT INTO businesses (owner_id, type, name, description, city, status) VALUES 
            ($dummy_user, 'restaurant', 'Dar El Jeld', 'Traditional Tunisian Cuisine', 'Tunis', 'approved'),
            ($dummy_user, 'restaurant', 'Le Golfe', 'Seafood & Mediterranean', 'La Marsa', 'approved'),
            ($dummy_user, 'restaurant', 'Pasta Cosi', 'Italian Fast Food', 'Sousse', 'approved')
        ");
    }
}

// Fetch Restaurants
$query = "SELECT * FROM businesses WHERE type = 'restaurant' AND status = 'approved' ORDER BY created_at DESC LIMIT 20";
$stmt = $db->prepare($query);
$stmt->execute();
$restaurants = $stmt->fetchAll();

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container" style="margin-bottom: 50px;">
    <!-- Food Hero -->
    <div style="background: linear-gradient(135deg, #FF9800, #F44336); color: white; padding: 50px 40px; border-radius: var(--border-radius-lg); margin-bottom: 40px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
        <div style="flex: 1; min-width: 300px;">
            <h1 style="font-size: 36px; margin-bottom: 10px;"><?= __('food') ?></h1>
            <p style="font-size: 18px; margin-bottom: 20px; opacity: 0.9;">Fast, fresh, and delicious. Delivered to your door.</p>
            <form style="display: flex; gap: 10px; max-width: 400px; width: 100%;">
                <input type="text" class="form-control" placeholder="Search restaurants or dishes..." style="border: none; padding: 15px;">
                <button type="submit" class="btn" style="background-color: var(--secondary-color); color: white; padding: 0 25px;"><i class="fa-solid fa-search"></i></button>
            </form>
        </div>
        <div style="text-align: right; display: none; @media(min-width: 768px){display: block;}">
            <i class="fa-solid fa-pizza-slice" style="font-size: 120px; opacity: 0.2; transform: rotate(15deg);"></i>
        </div>
    </div>

    <!-- Filters/Categories -->
    <div style="display: flex; gap: 15px; margin-bottom: 30px; overflow-x: auto; padding-bottom: 10px;">
        <button class="btn btn-primary" style="border-radius: 20px; padding: 8px 20px; white-space: nowrap;">All</button>
        <button class="btn btn-outline" style="border-radius: 20px; padding: 8px 20px; white-space: nowrap;">Pizza</button>
        <button class="btn btn-outline" style="border-radius: 20px; padding: 8px 20px; white-space: nowrap;">Tunisian</button>
        <button class="btn btn-outline" style="border-radius: 20px; padding: 8px 20px; white-space: nowrap;">Burgers</button>
        <button class="btn btn-outline" style="border-radius: 20px; padding: 8px 20px; white-space: nowrap;">Sushi</button>
        <button class="btn btn-outline" style="border-radius: 20px; padding: 8px 20px; white-space: nowrap;">Healthy</button>
    </div>

    <!-- Restaurant Grid -->
    <h3 style="margin-bottom: 20px;">Popular Restaurants</h3>
    
    <?php if (empty($restaurants)): ?>
        <div class="card text-center" style="padding: 60px 20px;">
            <i class="fa-solid fa-store-slash" style="font-size: 60px; color: var(--border-color); margin-bottom: 20px;"></i>
            <h3>No restaurants available</h3>
            <p style="color: var(--text-muted); margin-top: 10px;">We are expanding our network. Check back soon.</p>
        </div>
    <?php else: ?>
        <div class="grid grid-3">
            <?php foreach ($restaurants as $r): ?>
                <a href="restaurant.php?id=<?= $r['id'] ?>" class="card" style="text-decoration: none; color: inherit;">
                    <div style="height: 160px; background-color: var(--bg-color); position: relative;">
                        <?php if ($r['cover_image']): ?>
                            <img src="<?= APP_URL ?>/assets/img/<?= htmlspecialchars($r['cover_image']) ?>" alt="<?= htmlspecialchars($r['name']) ?>" style="width: 100%; height: 100%; object-fit: cover;">
                        <?php else: ?>
                            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;">
                                <i class="fa-solid fa-utensils" style="font-size: 40px; color: var(--border-color);"></i>
                            </div>
                        <?php endif; ?>
                        
                        <div style="position: absolute; top: 15px; right: 15px; background: white; padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.1); color: var(--text-main);">
                            <i class="fa-solid fa-star" style="color: var(--warning);"></i> 4.5 (120+)
                        </div>
                    </div>
                    <div class="card-body">
                        <h3 style="font-size: 18px; margin-bottom: 5px;"><?= htmlspecialchars($r['name']) ?></h3>
                        <p style="color: var(--text-muted); font-size: 14px; margin-bottom: 15px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><?= htmlspecialchars($r['description'] ?? 'Delicious food delivered to you') ?></p>
                        
                        <div style="display: flex; gap: 15px; font-size: 13px; color: var(--text-muted);">
                            <span><i class="fa-solid fa-motorcycle" style="margin-right: 5px;"></i> 20-30 min</span>
                            <span><i class="fa-solid fa-location-dot" style="margin-right: 5px;"></i> <?= htmlspecialchars($r['city'] ?? 'Tunisia') ?></span>
                        </div>
                    </div>
                </a>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</div>

<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
