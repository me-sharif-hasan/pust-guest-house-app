<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Ramsey\Collection\Collection;

class Room extends Model
{
    use HasFactory;
    public function guest_house():BelongsTo{
        return $this->belongsTo(GuestHouse::class,'id','guest_house_id');
    }
}
