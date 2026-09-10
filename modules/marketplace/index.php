<?php
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/functions.php';

$db = Database::getInstance();

// Auto-seed Categories if empty (For demo purposes on XAMPP)
$cat_check = $db->query("SELECT COUNT(*) FROM product_categories WHERE type = 'product'")->fetchColumn();
if ($cat_check == 0) {
    $db->query("INSERT INTO product_categories (name_en, name_fr, name_ar, type) VALUES 
        ('Electronics', 'Électronique', 'إلكترونيات', 'product'),
        ('Fashion', 'Mode', 'أزياء', 'product'),
        ('Home & Garden', 'Maison & Jardin', 'المنزل والحديقة', 'product'),
        ('Sports', 'Sports', 'رياضة', 'product')
    ");
}

// Fetch Categories based on language
$lang = isset($_SESSION['lang']) ? $_SESSION['lang'] : 'en';
$cat_col = 'name_' . $lang;
$categories = $db->query("SELECT id, $cat_col as name FROM product_categories WHERE type = 'product'")->fetchAll();

// Fetch Products
$cat_id = isset($_GET['cat']) ? (int)$_GET['cat'] : 0;
$query = "SELECT p.*, b.name as business_name FROM products p JOIN businesses b ON p.business_id = b.id WHERE p.status = 'active'";
$params = [];

if ($cat_id > 0) {
    $query .= " AND p.category_id = ?";
    $params[] = $cat_id;
}

$query .= " ORDER BY p.created_at DESC LIMIT 20";
$stmt = $db->prepare($query);
$stmt->execute($params);
$products = $stmt->fetchAll();

require_once __DIR__ . '/../../includes/header.php';
?>

<div class="container" style="margin-bottom: 50px;">
    <div style="background-color: var(--secondary-color); color: white; padding: 40px; border-radius: var(--border-radius-lg); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;">
        <div>
            <h1 style="margin-bottom: 10px;"><?= __('marketplace') ?></h1>
            <p style="color: #ADB5BD; font-size: 18px;">Discover products from local Tunisian businesses.</p>
        </div>
        <form style="display: flex; gap: 10px; max-width: 400px; width: 100%;">
            <input type="text" class="form-control" placeholder="<?= __('search') ?>" style="border: none;">
            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-search"></i></button>
        </form>
    </div>

    <div class="grid" style="grid-template-columns: 250px 1fr; gap: 30px;">
        <!-- Filters Sidebar -->
        <div class="sidebar">
            <div class="card">
                <div class="card-body">
                    <h3 style="margin-bottom: 15px; font-size: 18px;">Categories</h3>
                    <ul style="list-style: none;">
                        <li style="margin-bottom: 10px;">
                            <a href="index.php" style="color: <?= $cat_id == 0 ? 'var(--primary-color)' : 'var(--text-main)' ?>; font-weight: <?= $cat_id == 0 ? '600' : 'normal' ?>;">All Categories</a>
                        </li>
                        <?php foreach ($categories as $cat): ?>
                        <li style="margin-bottom: 10px;">
                            <a href="?cat=<?= $cat['id'] ?>" style="color: <?= $cat_id == $cat['id'] ? 'var(--primary-color)' : 'var(--text-main)' ?>; font-weight: <?= $cat_id == $cat['id'] ? '600' : 'normal' ?>;">
                                <?= htmlspecialchars($cat['name']) ?>
                            </a>
                        </li>
                        <?php endforeach; ?>
                    </ul>
                    
                    <hr style="border: 0; border-top: 1px solid var(--border-color); margin: 20px 0;">
                    
                    <h3 style="margin-bottom: 15px; font-size: 18px;">Price Range</h3>
                    <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                        <input type="number" class="form-control" placeholder="Min" style="padding: 8px;">
                        <input type="number" class="form-control" placeholder="Max" style="padding: 8px;">
                    </div>
                    <button class="btn btn-outline btn-block">Apply Filter</button>
                </div>
            </div>
        </div>
        
        <!-- Products Grid -->
        <div>
            <?php if (empty($products)): ?>
                <div class="card text-center" style="padding: 60px 20px;">
                    <i class="fa-solid fa-box-open" style="font-size: 60px; color: var(--border-color); margin-bottom: 20px;"></i>
                    <h3>No products found</h3>
                    <p style="color: var(--text-muted); margin-top: 10px;">Check back later or try a different category.</p>
                </div>
            <?php else: ?>
                <div class="grid grid-3">
                    <?php foreach ($products as $p): ?>
                        <div class="card">
                            <div style="height: 200px; background-color: var(--bg-color); display: flex; align-items: center; justify-content: center;">
                                <?php if ($p['image']): ?>
                                    <img src="<?= APP_URL ?>/assets/img/<?= htmlspecialchars($p['image']) ?>" alt="<?= htmlspecialchars($p['name']) ?>" style="max-width: 100%; max-height: 100%; object-fit: cover;">
                                <?php else: ?>
                                    <i class="fa-solid fa-image" style="font-size: 40px; color: var(--border-color);"></i>
                                <?php endif; ?>
                            </div>
                            <div class="card-body">
                                <span style="font-size: 12px; color: var(--text-muted); text-transform: uppercase; font-weight: 600;"><?= htmlspecialchars($p['business_name']) ?></span>
                                <h3 style="font-size: 16px; margin: 5px 0 10px; line-height: 1.4;"><?= htmlspecialchars($p['name']) ?></h3>
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                                    <span style="font-size: 18px; font-weight: 700; color: var(--primary-color);"><?= number_format($p['price'], 3) ?> TND</span>
                                    <button class="btn btn-primary" style="padding: 8px 15px;"><i class="fa-solid fa-cart-plus"></i></button>
                                </div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            <?php endif; ?>
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

<?php
require_once __DIR__ . '/../../includes/footer.php';
?>
