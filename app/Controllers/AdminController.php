<?php
declare(strict_types=1); namespace App\Controllers;
use App\Core\{Authorization,Auth,Csrf,Request,Response,View}; use App\Repositories\{AdminRepository,BusinessRepository,UserRepository};
final class AdminController {
 private AdminRepository $repo; private BusinessRepository $business; public function __construct(){ $this->repo=new AdminRepository();$this->business=new BusinessRepository(); }
 public function index(Request $r,array $p=[]):void{Authorization::requirePermission('admin.users');View::render('admin/index',['title'=>__('admin.title'),'stats'=>(new UserRepository())->stats(),'users'=>$this->repo->users(),'businesses'=>$this->repo->businesses(),'reports'=>$this->repo->reports()]);}
 public function userStatus(Request $r,array $p=[]):never{Authorization::requirePermission('admin.users');if(!Csrf::verify($r->post('_csrf'))){flash('error',__('security.csrf'));redirect_back('/admin');}$status=(string)$r->post('status');if(!in_array($status,['active','suspended','locked'],true))$status='active';$this->repo->setUserStatus((int)$p['id'],$status);redirect_back('/admin');}
 public function businessStatus(Request $r,array $p=[]):never{Authorization::requirePermission('business.approve');if(!Csrf::verify($r->post('_csrf'))){flash('error',__('security.csrf'));redirect_back('/admin');}$status=(string)$r->post('status');if(!in_array($status,['approved','suspended','rejected'],true))$status='rejected';$this->business->setStatus((int)$p['id'],$status,(int)Auth::id());redirect_back('/admin');}
 public function audit(Request $r,array $p=[]):void{Authorization::requirePermission('admin.audit');View::render('admin/audit',['title'=>__('admin.audit'),'rows'=>$this->repo->audit()]);}
}
