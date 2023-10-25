<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'title',
        'department',
        'phone',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    public function all_allocation_requests():HasMany{
        return $this->hasMany(AllocationRequest::class,'user_id','id');
    }
    public function pending_allocation_requests():HasMany{
        return $this->all_allocation_requests()->where('status','=','pending')->orWhere('status','=',null);
    }
    public function rejected_allocation_requests():HasMany{
        return $this->all_allocation_requests()->where('status','=','rejected');
    }
    public function approved_allocation_requests():HasMany{
        return $this->all_allocation_requests()->where('status','=','approved');
    }
    public function current_allocation():HasMany{
        return $this->approved_allocation_requests()->where('departure_date','>=',today());
    }
}
