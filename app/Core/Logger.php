<?php
declare(strict_types=1);
namespace App\Core;

final class Logger
{
    public static function write(string $channel, string $message, array $context = []): void {
        $line = '[' . gmdate('Y-m-d H:i:s') . '] ' . $message . ($context ? ' ' . json_encode($context, JSON_UNESCAPED_UNICODE) : '') . PHP_EOL;
        $path = base_path('storage/logs/' . preg_replace('/[^a-zA-Z0-9_-]/', '_', $channel) . '.log');
        file_put_contents($path, $line, FILE_APPEND | LOCK_EX);
    }
}
