<?php
declare(strict_types=1); namespace App\Controllers;
use App\Core\{Authorization,Auth,Request,View}; use App\Core\Database;
final class WalletController { public function index(Request $r,array $p=[]):void{Authorization::requireLogin();$db=Database::connect((array)config('database'));$s=$db->prepare('SELECT * FROM wallet_accounts WHERE user_id=? AND currency=\'TND\' LIMIT 1');$s->execute([Auth::id()]);$wallet=$s->fetch();$s=$db->prepare('SELECT * FROM wallet_transactions WHERE wallet_account_id=? ORDER BY created_at DESC LIMIT 50');$s->execute([(int)$wallet['id']]);View::render('modules/wallet',['title'=>__('wallet.title'),'wallet'=>$wallet,'transactions'=>$s->fetchAll()]);} }
