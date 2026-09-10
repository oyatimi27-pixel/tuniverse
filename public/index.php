<?php
declare(strict_types=1);
require_once dirname(__DIR__).'/bootstrap/bootstrap.php';
use App\Core\{Request,Router,Csrf,Logger,Response,Translation,View};
use App\Controllers\{HomeController,AuthController,DashboardController,ModuleController,BusinessController,AdminController,ProfileController,WalletController,ServiceController};
$request=new Request();
// CSRF gate for every state-changing browser request except routes that are explicitly JSON-only in future releases.
if($request->isPost() && !Csrf::verify($request->post('_csrf'))){ Logger::write('security','csrf_rejected',['path'=>$request->path()]); http_response_code(419); View::render('errors/csrf'); exit; }
$router=new Router();
$router->get('/',[HomeController::class,'index']);
$router->get('/lang/{locale}',[HomeController::class,'locale']);
$router->get('/login',[AuthController::class,'loginForm']);$router->post('/login',[AuthController::class,'login']);
$router->get('/register',[AuthController::class,'registerForm']);$router->post('/register',[AuthController::class,'register']);
$router->post('/logout',[AuthController::class,'logout']);
$router->get('/forgot-password',[AuthController::class,'forgotForm']);$router->post('/forgot-password',[AuthController::class,'forgot']);
$router->get('/reset-password/{token}',[AuthController::class,'resetForm']);$router->post('/reset-password/{token}',[AuthController::class,'reset']);
$router->get('/dashboard',[DashboardController::class,'index']);
$router->get('/profile',[ProfileController::class,'index']);$router->post('/profile/locale',[ProfileController::class,'locale']);
$router->get('/marketplace',[ModuleController::class,'marketplace']);$router->get('/marketplace/{id}',[ServiceController::class,'product']);$router->post('/marketplace/{id}/order',[ServiceController::class,'productOrder']);
$router->get('/food',[ModuleController::class,'food']);$router->get('/food/{id}',[ServiceController::class,'restaurant']);$router->post('/food/{id}/order',[ServiceController::class,'restaurantOrder']);
$router->get('/transport',[ModuleController::class,'transport']);$router->post('/transport/request',[ModuleController::class,'transportRequest']);
$router->get('/healthcare',[ModuleController::class,'healthcare']);$router->get('/healthcare/{id}',[ServiceController::class,'provider']);$router->post('/healthcare/{id}/book',[ServiceController::class,'book']);
$router->get('/education',[ModuleController::class,'education']);$router->post('/education/enroll/{id}',[ModuleController::class,'enroll']);
$router->get('/jobs',[ModuleController::class,'jobs']);$router->post('/jobs/apply/{id}',[ModuleController::class,'apply']);
$router->get('/news',[ModuleController::class,'news']);$router->get('/news/{id}',[ModuleController::class,'article']);
$router->get('/messages',[ModuleController::class,'messaging']);$router->get('/messages/{id}',[ModuleController::class,'messaging']);$router->post('/messages/{id}',[ModuleController::class,'sendMessage']);
$router->get('/wallet',[WalletController::class,'index']);
$router->get('/business',[BusinessController::class,'index']);$router->get('/business/create',[BusinessController::class,'createForm']);$router->post('/business/create',[BusinessController::class,'create']);$router->get('/business/product/create',[BusinessController::class,'productForm']);$router->post('/business/product/create',[BusinessController::class,'productCreate']);
$router->get('/admin',[AdminController::class,'index']);$router->post('/admin/users/{id}/status',[AdminController::class,'userStatus']);$router->post('/admin/businesses/{id}/status',[AdminController::class,'businessStatus']);$router->get('/admin/audit',[AdminController::class,'audit']);
$router->dispatch($request);
