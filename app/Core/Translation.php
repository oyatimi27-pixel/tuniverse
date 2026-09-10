<?php
declare(strict_types=1);
namespace App\Core;

final class Translation
{
    private static array $loaded = [];
    public static function getLocale(): string { return (string)Session::get('locale', config('app.default_locale')); }
    public static function setLocale(string $locale): void {
        if (!in_array($locale, config('app.supported_locales'), true)) $locale = (string)config('app.default_locale');
        Session::set('locale', $locale);
        if (Auth::check()) (new \App\Repositories\UserRepository())->updateLocale(Auth::id(), $locale);
    }
    public static function t(string $key, array $replace = []): string {
        $locale = self::getLocale(); $dict = self::dictionary($locale);
        $value = $dict[$key] ?? null;
        if ($value === null && $locale !== 'en') $value = self::dictionary('en')[$key] ?? $key;
        if ($value === null) $value = $key;
        foreach ($replace as $k => $v) $value = str_replace(':' . $k, (string)$v, $value);
        return $value;
    }
    public static function direction(): string { return self::getLocale() === 'ar' ? 'rtl' : 'ltr'; }
    private static function dictionary(string $locale): array {
        if (!isset(self::$loaded[$locale])) {
            $path = base_path('lang/' . $locale . '/app.php');
            self::$loaded[$locale] = is_file($path) ? require $path : [];
        }
        return self::$loaded[$locale];
    }
}
