<?php
declare(strict_types=1); namespace App\Controllers; use App\Core\{Auth,Authorization,Request,View}; use App\Repositories\ModuleRepository;
final class DashboardController { public function index(Request $r,array $p=[]):void{Authorization::requireLogin();$u=Auth::user();$stats=(new ModuleRepository())->dashboardCounts((int)$u['id']);View::render('dashboard/index',['title'=>__('nav.dashboard'),'user'=>$u,'stats'=>$stats]);} }
