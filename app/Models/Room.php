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
        return $this->belongsTo(GuestHouse::class,'id','guest_house_id');
    }
    public function getCurrentBordersAttribute(){
        $allocations=AllocationRequest::where('status','=','approved')->where('departure_date','>=',Carbon::now())->get();
        foreach ($allocations as &$allocation){
            $allocation->user;
        }

    }
}
