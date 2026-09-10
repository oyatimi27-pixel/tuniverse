<?php
declare(strict_types=1);
if (PHP_SAPI !== 'cli') { http_response_code(403); exit("CLI only\n"); }
require_once __DIR__.'/../bootstrap/bootstrap.php';
use App\Core\Database;
$db=Database::connect((array)config('database'));
$email=$argv[1]??null;$password=$argv[2]??null;$name=$argv[3]??'Tuniverse Administrator';
if(!$email||!$password||!filter_var($email,FILTER_VALIDATE_EMAIL)){fwrite(STDERR,"Usage: php tools/create_admin.php email password [display-name]\n");exit(1);}
if(strlen($password)<10){fwrite(STDERR,"Password must be at least 10 characters.\n");exit(1);}
$s=$db->prepare('SELECT id FROM users WHERE email=? LIMIT 1');$s->execute([$email]);if($s->fetch()){fwrite(STDERR,"User already exists.\n");exit(1);}
$db->beginTransaction();try{$s=$db->prepare('INSERT INTO users(email,password_hash,status,email_verified_at) VALUES(?,?,\'active\',UTC_TIMESTAMP())');$s->execute([strtolower($email),password_hash($password,PASSWORD_DEFAULT)]);$id=(int)$db->lastInsertId();$parts=preg_split('/\s+/',trim($name),2);$s=$db->prepare('INSERT INTO user_profiles(user_id,first_name,last_name,display_name,preferred_locale) VALUES(?,?,?,?,\'fr\')');$s->execute([$id,$parts[0]??$name,$parts[1]??null,$name]);$s=$db->prepare("INSERT INTO user_roles(user_id,role_id) SELECT ?,id FROM roles WHERE slug='super_administrator'");$s->execute([$id]);$s=$db->prepare('INSERT INTO wallet_accounts(user_id,currency,status) VALUES(?,\'TND\',\'active\')');$s->execute([$id]);$db->commit();echo "Super Administrator created. User ID: {$id}\n";}catch(Throwable $e){$db->rollBack();fwrite(STDERR,$e->getMessage()."\n");exit(1);}
