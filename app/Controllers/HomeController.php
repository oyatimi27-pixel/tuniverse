<?php
declare(strict_types=1); namespace App\Controllers;
use App\Core\View; use App\Core\Translation; use App\Core\Request;
final class HomeController {
 public function index(Request $r,array $p=[]):void{View::render('home',['title'=>__('app.name'),'locale'=>Translation::getLocale()]);}
 public function locale(Request $r,array $p=[]):never{\App\Core\Translation::setLocale((string)($p['locale']??'fr')); redirect_back('/');}
}
