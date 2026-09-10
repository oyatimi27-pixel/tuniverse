<?php
declare(strict_types=1);
namespace App\Core;

final class Csrf
{
    public static function token(): string
    {
        $token = Session::get('_csrf');
        if (!is_string($token) || strlen($token) < 32) {
            $token = bin2hex(random_bytes((int)config('security.csrf_bytes')));
            Session::set('_csrf', $token);
        }
        return $token;
    }
    public static function verify(?string $token): bool {
        return is_string($token) && hash_equals(self::token(), $token);
    }
}
