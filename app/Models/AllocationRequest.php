<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class AllocationRequest extends Model
{
    use HasFactory;
    protected $appends=['assigned_rooms'];

    public function user():BelongsTo{
        return $this->belongsTo(User::class,'user_id','id');
    }
    public function guest_house():BelongsTo{
        return $this->belongsTo(GuestHouse::class,'guest_house_id','id');
    }
    public function getFeeAttribute(){
        $c = Charges::where('room_type','=',$this->room_type)->where('booking_type','=',$this->booking_type)->where('guest_house_id','=',$this->guest_house_id)->get();
        return count($c)>0?$c[0]:[
            'status'=>'error',
            'message'=>'This specific room combination not exists!',
            'code'=>0x901
        ];
    }

    public function getAssignedRoomsAttribute(){
        return $this->room()->get();
    }
    public function getGuestHouseAttribute(){
        return $this->guest_house()->get();
    }

    public function room():BelongsToMany{
        return $this->belongsToMany(Room::class);
    }

    protected $fillable=[
        'user_id',
        'guest_house_id',
        'boarding_date',
        'departure_date',
        'room_type',
        'booking_type',
        'bed_number',
        'guest_count',
        'status',
        'is_user_seen',
        'is_admin_seen',
        'days_count',
        'behalf_of',
        'boarder_type',
        'rejection_reason',
        'cancellation_reason',
        'allocation_purpose'
    ];

    /**
     * @param AllocationRequest[]|AllocationRequest|Collection $allocationRequest
     * @return AllocationRequest
     */
    public static function filter($allocationRequest){
        if(is_array($allocationRequest)||$allocationRequest instanceof Collection){
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
