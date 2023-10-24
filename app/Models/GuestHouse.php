<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class GuestHouse extends Model
{
    use HasFactory;
    public function rooms():HasMany{
        return $this->hasMany(Room::class,'guest_house_id','id');
    }
    public function allocation():HasMany{
        return $this->hasMany(AllocationRequest::class,'guest_house_id','id')->where('status','=','approved');
    }
    public function all_allocation_requests():HasMany{
        return $this->hasMany(AllocationRequest::class,'guest_house_id','id');
    }
}
