<?php
declare(strict_types=1);
namespace App\Core;

final class Session
{
    public static function start(string $name, bool $secure): void
    {
        if (session_status() === PHP_SESSION_ACTIVE) return;
        session_name($name);
        session_set_cookie_params([
            'lifetime' => 0,
            'path' => '/',
            'secure' => $secure,
            'httponly' => true,
            'samesite' => 'Lax',
        ]);
        session_start();
    }
    public static function regenerate(): void { session_regenerate_id(true); }
    public static function get(string $key, mixed $default = null): mixed { return $_SESSION[$key] ?? $default; }
    public static function set(string $key, mixed $value): void { $_SESSION[$key] = $value; }
    public static function remove(string $key): void { unset($_SESSION[$key]); }
    public static function flash(string $key, ?string $value = null): ?string {
        if ($value !== null) { $_SESSION['_flash'][$key] = $value; return null; }
        $v = $_SESSION['_flash'][$key] ?? null; unset($_SESSION['_flash'][$key]); return $v;
    }
}
