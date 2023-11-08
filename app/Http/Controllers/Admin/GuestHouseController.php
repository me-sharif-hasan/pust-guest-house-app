<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GuestHouse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

//error group 1100
class GuestHouseController extends Controller
{
    public function create(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
               'title'=>'required',
               'address'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $guestHouse=new GuestHouse();
            $guestHouse->fill($data);
            $guestHouse->save();
            return [
                'status'=>'success',
                'message'=>'Guest house created',
                'data'=>[
                    'guest_house'=>$guestHouse
                ]
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1101
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not create guest house. Something went wrong!',
                'code'=>0x1102
            ];
        }
    }

    public function update(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $guestHouse=GuestHouse::find($data['id']);
            $guestHouse->fill($data);
            $guestHouse->save();
            return [
                'status'=>'success',
                'message'=>'Guest house updated',
                'data'=>[
                    'guest_house'=>$guestHouse
                ]
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1103
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not update guest house. Something went wrong!',
                'code'=>0x1104
            ];
        }
    }

    public function delete(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $guestHouse=GuestHouse::find($data['id']);
            $guestHouse->delete();
            return [
                'status'=>'success',
                'message'=>'Guest house deleted'
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1105
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not delete guest house. Something went wrong!',
                'code'=>0x1106
            ];
        }
    }
}
