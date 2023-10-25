<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::prefix('v1')->group(function (){
    Route::any('/login',[\App\Http\Controllers\UserLoginAndRegistrationController::class,'login'])->name('login');
    Route::middleware('auth:sanctum')->prefix('')->group(function (){
        Route::prefix("user")->group(function (){
            Route::get('details', function (Request $request) { return $request->user();});
            Route::post('update', [\App\Http\Controllers\UserController::class,'update']);
        });
        Route::prefix('/public')->group(function (){
            Route::prefix('allocation')->group(function (){
                Route::get('all',[\App\Http\Controllers\BookingController::class,'all']);
                Route::get('pending',[\App\Http\Controllers\BookingController::class,'pending']);
                Route::get('rejected',[\App\Http\Controllers\BookingController::class,'rejected']);
                Route::get('approved',[\App\Http\Controllers\BookingController::class,'approved']);
                Route::get('current',[\App\Http\Controllers\BookingController::class,'current']);

                Route::post('new',[\App\Http\Controllers\BookingController::class,'new']);
                Route::post('update',[\App\Http\Controllers\BookingController::class,'update']);
                Route::post('extend',[\App\Http\Controllers\BookingController::class,'extend']);
                Route::post('delete',[\App\Http\Controllers\BookingController::class,'delete']);
            });
        });

        Route::prefix('/admin')->middleware('admin')->group(function (){
            Route::prefix('allocation')->group(function (){
                Route::get('all',[\App\Http\Controllers\Admin\AdminBookingController::class,'all']);
                Route::get('pending',[\App\Http\Controllers\Admin\AdminBookingController::class,'pending']);
                Route::get('rejected',[\App\Http\Controllers\BookingController::class,'rejected']);
                Route::get('approved',[\App\Http\Controllers\BookingController::class,'approved']);
                Route::get('current',[\App\Http\Controllers\BookingController::class,'current']);

                Route::post('new',[\App\Http\Controllers\BookingController::class,'new']);
                Route::post('update',[\App\Http\Controllers\BookingController::class,'update']);
                Route::post('extend',[\App\Http\Controllers\BookingController::class,'extend']);
                Route::post('delete',[\App\Http\Controllers\BookingController::class,'delete']);
            });
        });
    });
});




