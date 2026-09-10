<?php
declare(strict_types=1); namespace App\Controllers;
use App\Core\{Auth,Authorization,Csrf,Request,Response,View}; use App\Repositories\UserRepository;
final class ProfileController { public function index(Request $r,array $p=[]):void{Authorization::requireLogin();View::render('profile',['title'=>__('nav.profile'),'user'=>(new UserRepository())->findById((int)Auth::id())]);} public function locale(Request $r,array $p=[]):never{Authorization::requireLogin();if(!Csrf::verify($r->post('_csrf'))){flash('error',__('security.csrf'));redirect_back('/profile');}\App\Core\Translation::setLocale((string)$r->post('locale'));redirect_back('/profile');} }
