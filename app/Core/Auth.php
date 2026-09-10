<?php
declare(strict_types=1);
namespace App\Core;

use App\Repositories\UserRepository;

final class Auth
{
    private static ?array $user = null;
    public static function user(): ?array {
        if (self::$user !== null) return self::$user;
        $id = Session::get('user_id');
        if (!$id) return null;
        $user = (new UserRepository())->findById((int)$id);
        if (!$user || $user['status'] !== 'active') { self::logout(false); return null; }
        self::$user = $user;
        return $user;
    }
    public static function login(array $user): void {
        Session::regenerate();
        Session::set('user_id', (int)$user['id']);
        Session::set('authenticated_at', time());
        self::$user = $user;
    }
    public static function logout(bool $redirect = true): void {
        self::$user = null;
        Session::remove('user_id');
        Session::remove('authenticated_at');
        if ($redirect) Response::redirect('/login');
    }
    public static function check(): bool { return self::user() !== null; }
    public static function id(): ?int { $u = self::user(); return $u ? (int)$u['id'] : null; }
}
