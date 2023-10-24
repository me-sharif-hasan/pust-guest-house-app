<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class AllocationRequest extends Model
{
    use HasFactory;

    public function user():BelongsTo{
        return $this->belongsTo(User::class,'user_id','id');
    }
    public function guest_house():BelongsTo{
        return $this->belongsTo(GuestHouse::class,'guest_house_id','id');
    }

    public function room():HasOne{
        return $this->hasOne(Room::class,'id','room_id');
    }

    protected $fillable=[
        'user_id',
        'guest_house_id',
        'boarding_date',
        'departure_date',
        'status'
    ];

    public static function filter(AllocationRequest $allocationRequest){
        if(is_array($allocationRequest)){
            foreach ($allocationRequest as &$a){
                $expire_date=$a->departure_date;
                if($expire_date<Carbon::now()){
                    $a->status="expired";
                    $a->save();
                }
            }
        }else{
            $expire_date=$allocationRequest->departure_date;
            if($expire_date<Carbon::now()){
                $allocationRequest->status="expired";
                $allocationRequest->save();
            }
        }

        return $allocationRequest;
    }
}
