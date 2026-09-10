<?php
declare(strict_types=1);
namespace App\Core;

final class Upload
{
    public static function image(?array $file): ?array {
        if (!$file || ($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) return null;
        if (($file['error'] ?? UPLOAD_ERR_OK) !== UPLOAD_ERR_OK) throw new \RuntimeException(__('upload.failed'));
        if (($file['size'] ?? 0) > (int)config('security.upload_max_bytes')) throw new \RuntimeException(__('upload.too_large'));
        $finfo = new \finfo(FILEINFO_MIME_TYPE); $mime = $finfo->file($file['tmp_name']);
        $allowed = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
        if (!isset($allowed[$mime])) throw new \RuntimeException(__('upload.invalid_type'));
        $ext = $allowed[$mime]; $name = bin2hex(random_bytes(16)) . '.' . $ext;
        $relative = 'uploads/' . date('Y/m') . '/' . $name; $full = base_path('public/' . $relative);
        if (!is_dir(dirname($full))) mkdir(dirname($full), 0775, true);
        if (!move_uploaded_file($file['tmp_name'], $full)) throw new \RuntimeException(__('upload.failed'));
        return ['path' => $relative, 'original_name' => basename((string)$file['name']), 'mime_type' => $mime, 'extension' => $ext, 'size_bytes' => filesize($full) ?: 0];
    }
}
