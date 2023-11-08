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
    Route::any('/registration',[\App\Http\Controllers\UserLoginAndRegistrationController::class,'registration'])->name('registration');
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

                Route::get("cancel-extension",[\App\Http\Controllers\BookingController::class,'cancelExtend']);
            });
        });

        Route::prefix('/admin')->middleware('admin')->group(function (){
            Route::prefix('allocation')->group(function (){
                /**
                 * Fetching allocations
                 */
                Route::get('all',[\App\Http\Controllers\Admin\AdminBookingController::class,'all']);
                Route::get('pending',[\App\Http\Controllers\Admin\AdminBookingController::class,'pending']);
                Route::get('rejected',[\App\Http\Controllers\BookingController::class,'rejected']);
                Route::get('approved',[\App\Http\Controllers\BookingController::class,'approved']);
                Route::get('current',[\App\Http\Controllers\BookingController::class,'current']);
                Route::get('extension-requests',[\App\Http\Controllers\Admin\AdminBookingController::class,'extensionRequests']);

                Route::post('update',[\App\Http\Controllers\Admin\AdminBookingController::class,'update']);
                Route::post('delete',[\App\Http\Controllers\Admin\AdminBookingController::class,'delete']);
            });

            Route::prefix('guest-houses')->group(function (){
               Route::get('',[\App\Http\Controllers\common\GuestHouseController::class,'list']);
               Route::post('create',[\App\Http\Controllers\Admin\GuestHouseController::class,'create']);
               Route::post('update',[\App\Http\Controllers\Admin\GuestHouseController::class,'update']);
               Route::post('delete',[\App\Http\Controllers\Admin\GuestHouseController::class,'delete']);
            });

            Route::prefix('rooms')->group(function (){
                Route::get('',[\App\Http\Controllers\common\RoomController::class,'list']);
                Route::post('create',[\App\Http\Controllers\Admin\RoomController::class,'create']);
                Route::post('update',[\App\Http\Controllers\Admin\RoomController::class,'update']);
                Route::post('delete',[\App\Http\Controllers\Admin\RoomController::class,'delete']);
            });

            Route::prefix('users')->group(function (){
               Route::get('',[\App\Http\Controllers\Admin\UserController::class,'list']);
               Route::post('details',[\App\Http\Controllers\Admin\UserController::class,'details']);
               Route::post('update',[\App\Http\Controllers\Admin\UserController::class,'update']);
               Route::post('delete',[\App\Http\Controllers\Admin\UserController::class,'delete']);
            });
        });

        Route::prefix('common')->group(function (){
           Route::get('guest-house-list',[\App\Http\Controllers\common\GuestHouseController::class,'list']);
           Route::get('room-list',[\App\Http\Controllers\common\RoomController::class,'list']);
        });
    });
});




