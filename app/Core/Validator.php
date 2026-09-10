<?php
declare(strict_types=1);
namespace App\Core;

final class Validator
{
    private array $errors = [];
    public function required(string $field, mixed $value, string $message): self { if ($value === null || trim((string)$value) === '') $this->errors[$field] = $message; return $this; }
    public function email(string $field, string $value, string $message): self { if (!filter_var($value, FILTER_VALIDATE_EMAIL)) $this->errors[$field] = $message; return $this; }
    public function min(string $field, string $value, int $len, string $message): self { if (mb_strlen($value) < $len) $this->errors[$field] = $message; return $this; }
    public function match(string $field, string $a, string $b, string $message): self { if (!hash_equals($a, $b)) $this->errors[$field] = $message; return $this; }
    public function numericPositive(string $field, mixed $value, string $message): self { if (!is_numeric($value) || (float)$value <= 0) $this->errors[$field] = $message; return $this; }
    public function errors(): array { return $this->errors; }
    public function fails(): bool { return $this->errors !== []; }
}
