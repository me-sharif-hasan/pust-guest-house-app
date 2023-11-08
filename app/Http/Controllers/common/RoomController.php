<?php

namespace App\Http\Controllers\common;

use App\Http\Controllers\Controller;
use App\Models\GuestHouse;
use App\Models\Room;
use Illuminate\Http\Request;
//error group 1200
class RoomController extends Controller
{
    public function list(){
        try {
            $rooms=null;
            $data=\request()->json()->all();
            if(isset($data['guest_house_id'])){
                $rooms=Room::where('guest_house_id','=',$data['guest_house_id'])->get();
            }else{
                $rooms=Room::all();
            }
            return [
                'status'=>'success',
                'message'=>'Fetch successful',
                'data'=>[
                    'list'=>$rooms
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
