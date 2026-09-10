<?php
declare(strict_types=1);
namespace App\Core;

use App\Repositories\UserRepository;

final class Authorization
{
    public static function hasPermission(string $permission): bool
    {
        $user = Auth::user();
        return $user ? (new UserRepository())->hasPermission((int)$user['id'], $permission) : false;
    }
    public static function hasRole(string $role): bool
    {
        $user = Auth::user();
        return $user ? (new UserRepository())->hasRole((int)$user['id'], $role) : false;
    }
    public static function requireLogin(): void { if (!Auth::check()) Response::redirect('/login'); }
    public static function requirePermission(string $permission): void {
        self::requireLogin();
        if (!self::hasPermission($permission)) { http_response_code(403); View::render('errors/403'); exit; }
    }
}
