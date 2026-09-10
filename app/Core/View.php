<?php
declare(strict_types=1);
namespace App\Core;

final class View
{
    public static function render(string $view, array $data = [], string $layout = 'layouts/app'): void
    {
        extract($data, EXTR_SKIP);
        $viewFile = base_path('app/Views/' . $view . '.php');
        $layoutFile = base_path('app/Views/' . $layout . '.php');
        if (!is_file($viewFile) || !is_file($layoutFile)) throw new \RuntimeException('View not found: ' . $view);
        ob_start(); require $viewFile; $content = ob_get_clean();
        require $layoutFile;
    }
}
