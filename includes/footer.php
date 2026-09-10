    </main>
    
    <footer class="footer">
        <div class="container footer-container">
            <div class="footer-col">
                <h3><?= __('app_name') ?></h3>
                <p><?= __('slogan') ?></p>
                <div class="social-links">
                    <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#"><i class="fa-brands fa-twitter"></i></a>
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                </div>
            </div>
            
            <div class="footer-col">
                <h4><?= __('services') ?></h4>
                <a href="<?= APP_URL ?>/modules/marketplace/index.php"><?= __('marketplace') ?></a>
                <a href="<?= APP_URL ?>/modules/food/index.php"><?= __('food') ?></a>
                <a href="<?= APP_URL ?>/modules/transport/index.php"><?= __('transport') ?></a>
                <a href="<?= APP_URL ?>/modules/healthcare/index.php"><?= __('healthcare') ?></a>
            </div>
            
            <div class="footer-col">
                <h4><?= __('app_name') ?></h4>
                <a href="<?= APP_URL ?>/about.php">About Us</a>
                <a href="<?= APP_URL ?>/contact.php">Contact</a>
                <a href="<?= APP_URL ?>/privacy.php">Privacy Policy</a>
                <a href="<?= APP_URL ?>/terms.php">Terms of Service</a>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="container">
                <p>&copy; <?= date('Y') ?> <?= __('app_name') ?>. All Rights Reserved.</p>
            </div>
        </div>
    </footer>
    
    <!-- Scripts -->
    <script src="<?= APP_URL ?>/assets/js/main.js"></script>
</body>
</html>
