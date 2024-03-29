<?php

namespace App\Http\Controllers\Admin;

use App\Exceptions\SafeException;
use App\Http\Controllers\Controller;
use App\Models\GuestHouse;
use App\Models\Room;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

//error group 1300
class RoomController extends Controller
{
    public function create(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'number'=>'required',
                'guest_house_id'=>'required',
                'room_type'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $room=new Room();
            $room->fill($data);
            $room->save();
            return [
                'status'=>'success',
                'message'=>'Room created',
                'data'=>[
                    'room'=>$room
                ]
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1301
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not create room. Something went wrong!',
                'code'=>0x1302
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
            $room=Room::find($data['id']);
            if(isset($room['parent_id'])&&$room['parent_id']==$room->id){
                throw new SafeException("You can not set same room as bed");
            }
            $room->fill($data);
            $room->save();
            return [
                'status'=>'success',
                'message'=>'room updated',
                'data'=>[
                    'room'=>$room
                ]
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1303
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not update room. Something went wrong!',
                'code'=>0x1304
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
            $room=Room::find($data['id']);
            $room->delete();
            return [
                'status'=>'success',
                'message'=>'Room deleted'
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1305
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not delete room. Something went wrong!',
                'code'=>0x1306
            ];
        }
    }


    public function status(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $room=Room::find($data['id']);
//            $room->delete();
            return [
                'status'=>'success',
                'message'=>'Room deleted'
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1307
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not delete room. Something went wrong!',
                'code'=>0x1308
            ];
        }
    }

    public function getParentRooms(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'guest_house_id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $rooms=GuestHouse::find($data['guest_house_id'])->rooms->where('parent_id','=',null)->sortBy('id');
            $roomList=[];
            foreach ($rooms as $room){
                $roomList[]=$room;
            }

            return [
                'status'=>'success',
                'message'=>'Fetch successful',
                'data'=>$roomList
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1309
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Can not delete room. Something went wrong!',
                'code'=>0x1310
            ];
        }
    }
}
