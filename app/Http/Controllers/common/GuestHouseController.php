<?php

namespace App\Http\Controllers\common;

use App\Http\Controllers\Controller;
use App\Models\GuestHouse;
use Illuminate\Http\Request;

class GuestHouseController extends Controller
{
    //error group 100
    public function list(){
        try {
            $guest_houses=GuestHouse::all();
            return [
                'status'=>'success',
                'message'=>'Fetch successful',
                'data'=>[
                    'list'=>$guest_houses
                ]
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Operation failed!',
                'code'=>0x1001
            ];
        }
    }
}
