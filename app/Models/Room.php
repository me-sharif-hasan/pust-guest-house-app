<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Ramsey\Collection\Collection;

class Room extends Model
{
    use HasFactory;
    protected $fillable=[
        'number',
        'guest_house_id',
        'room_type',
    ];
    protected $appends=['current_borders'];
    public function guest_house():BelongsTo{
        return $this->belongsTo(GuestHouse::class,'guest_house_id','id');
    }
    public function getCurrentBordersAttribute(){
        $allocations=AllocationRequest::where('status','=','approved')->where('guest_house_id','=',$this->guest_house()->first()->id)->where('departure_date','>=',Carbon::now())->where('boarding_date','<=',Carbon::now())->get();
        $users=[];
        foreach ($allocations as &$allocation){
            if($allocation->assigned_rooms){
                foreach ($allocation->assigned_rooms as $room){
                    if($room->id==$this->id){
                        $users[]=$allocation->user;
                    }
                }
            }
        }
        return $users;
    }

}
