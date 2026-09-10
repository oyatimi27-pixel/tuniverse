<?php
declare(strict_types=1);
require_once __DIR__ . '/../app/Core/helpers.php';
require_once __DIR__ . '/../app/Core/Database.php';
require_once __DIR__ . '/../app/Core/Request.php';
require_once __DIR__ . '/../app/Core/Response.php';
require_once __DIR__ . '/../app/Core/Session.php';
require_once __DIR__ . '/../app/Core/Csrf.php';
require_once __DIR__ . '/../app/Core/Logger.php';
require_once __DIR__ . '/../app/Core/Validator.php';
require_once __DIR__ . '/../app/Core/Translation.php';
require_once __DIR__ . '/../app/Core/View.php';
require_once __DIR__ . '/../app/Core/Router.php';
require_once __DIR__ . '/../app/Core/Auth.php';
require_once __DIR__ . '/../app/Core/Authorization.php';
require_once __DIR__ . '/../app/Core/Upload.php';
spl_autoload_register(function(string $class): void { if (!str_starts_with($class,'App\\')) return; $file=base_path(str_replace('App\\','app/',$class).'.php'); if(is_file($file)) require_once $file; });
date_default_timezone_set((string)config('app.timezone'));
\App\Core\Session::start((string)config('app.session_name'),(bool)config('security.cookie_secure'));
\App\Core\Database::connect((array)config('database'));
// Restore persistent login and enforce idle session lifetime.
if (!\App\Core\Auth::check() && !empty($_COOKIE['tuniverse_remember'])) {
    $remember = (new \App\Repositories\UserRepository())->findRememberToken((string)$_COOKIE['tuniverse_remember']);
    if ($remember) { \App\Core\Auth::login($remember); } else { setcookie('tuniverse_remember','',['expires'=>time()-3600,'path'=>'/','secure'=>(bool)config('security.cookie_secure'),'httponly'=>true,'samesite'=>'Lax']); }
}
$authAt=\App\Core\Session::get('authenticated_at');
if ($authAt && (time()-(int)$authAt) > ((int)config('app.session_minutes')*60)) { \App\Core\Auth::logout(false); \App\Core\Session::flash('error',__('auth.session_expired')); }
if (\App\Core\Auth::check()) { \App\Core\Session::set('authenticated_at', time()); }
