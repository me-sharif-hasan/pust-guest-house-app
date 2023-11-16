<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AllocationRequest;
use App\Models\GuestHouse;
use App\Models\Room;
use Carbon\Carbon;
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

    public function getAvailableRoomList(){
        try{
            $data=\request()->json()->all();
            $guestHouseId=$data['guest_house_id'];
            $guestHouse=GuestHouse::find($guestHouseId);
            $rooms=$guestHouse->rooms;

            $boarding_date=Carbon::now();
            $departure_date=Carbon::now();
            if(isset($data['allocation_id'])){
                $allocation=AllocationRequest::find($data['allocation_id']);
                $boarding_date=$allocation->boarding_date;
                $departure_date=$allocation->departure_date;
            }

            $allocations=AllocationRequest::where('status','=','approved')->where('guest_house_id','=',$guestHouseId)->where('departure_date','>=',$departure_date)->where('boarding_date','<=',$boarding_date)->get();
            $counter=[];
            if($allocations!=null){
                foreach ($allocations as $allocation){
                    $assigned_rooms = $allocation->assigned_rooms;
                    if($assigned_rooms==null) continue;
                    foreach ($assigned_rooms as $room){
                        $counter[$room->id]=isset($counter[$room->id])?$counter[$room->id]+1:1;
                        $counter[$room->room->id]=isset($counter[$room->room->id])?$counter[$room->room->id]+1:1; //also increase base room count
                    }
                }
            }
            foreach ($rooms as &$room){
                $room->border_count= $counter[$room->id] ?? 0;
            }
            return [
                'status'=>'success',
                'message'=>'Room list fetched',
                'data'=>[
                    'rooms'=>$rooms
                ]
            ];

        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1107
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Something went wrong when requesting room list!'.$e->getMessage(),
                'code'=>0x1108
            ];
        }
    }
}
