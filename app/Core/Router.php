<?php
declare(strict_types=1);
namespace App\Core;

final class Router
{
    private array $routes = [];
    public function get(string $path, callable|array $handler): void { $this->add('GET', $path, $handler); }
    public function post(string $path, callable|array $handler): void { $this->add('POST', $path, $handler); }
    private function add(string $method, string $path, callable|array $handler): void { $this->routes[] = [$method, rtrim($path, '/') ?: '/', $handler]; }
    public function dispatch(Request $request): void {
        foreach ($this->routes as [$method, $path, $handler]) {
            if ($method !== $request->method()) continue;
            $regex = '#^' . preg_replace('#\{([^}]+)\}#', '(?P<$1>[^/]+)', $path) . '$#';
            if (preg_match($regex, $request->path(), $m)) {
                $params = array_filter($m, fn($k) => !is_int($k), ARRAY_FILTER_USE_KEY);
                $controller = is_array($handler) ? new $handler[0]() : null;
                $action = is_array($handler) ? $handler[1] : null;
                if ($controller) { $controller->$action($request, $params); return; }
                $handler($request, $params); return;
            }
        }
        http_response_code(404); View::render('errors/404');
    }
}
