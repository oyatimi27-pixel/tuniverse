<?php use App\Core\{Auth,Translation}; $user=Auth::user(); ?>
<!doctype html><html lang="<?=e(Translation::getLocale())?>" dir="<?=e(Translation::direction())?>"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="description" content="<?=e(__('hero.subtitle'))?>"><title><?=e($title ?? __('app.name'))?> · <?=e(__('app.name'))?></title><link rel="stylesheet" href="<?=e(url('/assets/css/app.css'))?>"></head><body>
<?php require base_path('app/Views/partials/header.php'); ?>
<main class="site-main"><div class="container"><?php if($m=display_flash('success')): ?><div class="flash success"><?=e($m)?></div><?php endif; ?><?php if($m=display_flash('error')): ?><div class="flash error"><?=e($m)?></div><?php endif; ?><?= $content ?></div></main>
<?php require base_path('app/Views/partials/footer.php'); ?><script src="<?=e(url('/assets/js/app.js'))?>"></script></body></html>
