<?php
declare(strict_types=1);
namespace App\Core;

final class Request
{
    public function method(): string { return strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET'); }
    public function path(): string {
        $uri = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
        $base = rtrim((string)config('app.base_path'), '/');
        if ($base && str_starts_with($uri, $base)) $uri = substr($uri, strlen($base)) ?: '/';
        return '/' . trim($uri, '/');
    }
    public function input(string $key, mixed $default = null): mixed { return $_POST[$key] ?? $_GET[$key] ?? $default; }
    public function post(string $key, mixed $default = null): mixed { return $_POST[$key] ?? $default; }
    public function query(string $key, mixed $default = null): mixed { return $_GET[$key] ?? $default; }
    public function isPost(): bool { return $this->method() === 'POST'; }
}
