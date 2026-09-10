<?php
declare(strict_types=1); namespace App\Repositories; use App\Core\Repository;
final class AdminRepository extends Repository {
 public function users():array{return $this->db->query('SELECT u.id,u.email,u.phone,u.status,u.created_at,GROUP_CONCAT(r.slug SEPARATOR ", ") roles FROM users u LEFT JOIN user_roles ur ON ur.user_id=u.id LEFT JOIN roles r ON r.id=ur.role_id WHERE u.deleted_at IS NULL GROUP BY u.id ORDER BY u.created_at DESC LIMIT 100')->fetchAll();}
 public function businesses():array{return $this->db->query('SELECT b.*,u.email owner_email FROM businesses b JOIN users u ON u.id=b.owner_user_id WHERE b.deleted_at IS NULL ORDER BY FIELD(b.status,"pending_review","approved","rejected","suspended","draft"),b.created_at DESC LIMIT 100')->fetchAll();}
 public function reports():array{return $this->db->query('SELECT * FROM reports ORDER BY created_at DESC LIMIT 100')->fetchAll();}
 public function audit():array{return $this->db->query('SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT 150')->fetchAll();}
 public function setUserStatus(int $id,string $status):void{$s=$this->db->prepare('UPDATE users SET status=? WHERE id=?');$s->execute([$status,$id]);}
}
