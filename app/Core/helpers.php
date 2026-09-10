<?php
declare(strict_types=1);
use App\Core\Translation;
use App\Core\Csrf;
function base_path(string $path = ''): string { $root = dirname(__DIR__, 2); return $path ? $root . DIRECTORY_SEPARATOR . ltrim($path, '/\\') : $root; }
function config(?string $key = null): mixed { static $c; if ($c === null) $c = require base_path('config/config.php'); if ($key === null) return $c; $v=$c; foreach (explode('.', $key) as $p) $v=$v[$p]??null; return $v; }
function url(string $path = '/'): string { return rtrim((string)config('app.base_path'), '/') . '/' . ltrim($path, '/'); }
function e(mixed $value): string { return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }
function __(string $key, array $replace = []): string { return Translation::t($key, $replace); }
function csrf_field(): string { return '<input type="hidden" name="_csrf" value="' . e(Csrf::token()) . '">'; }
function old(string $key, mixed $default=''): mixed { return $_SESSION['_old'][$key] ?? $default; }
function remember_old(array $data): void { $_SESSION['_old'] = $data; }
function clear_old(): void { unset($_SESSION['_old']); }
function flash(string $key, string $message): void { \App\Core\Session::flash($key, $message); }
function display_flash(string $key): ?string { return \App\Core\Session::flash($key); }
function money(mixed $amount, string $currency='TND'): string { return number_format((float)$amount, 3, '.', ' ') . ' ' . $currency; }
function slugify(string $text): string { $text = trim(mb_strtolower($text)); $text = preg_replace('/[^\pL\pN]+/u', '-', $text) ?? ''; $text = trim($text, '-'); return $text !== '' ? $text : bin2hex(random_bytes(4)); }
function redirect_back(string $fallback='/'): never { $ref = $_SERVER['HTTP_REFERER'] ?? ''; $base = url('/'); if ($ref && str_starts_with($ref, $base)) { header('Location: '.$ref); } else { header('Location: '.url($fallback)); } exit; }
