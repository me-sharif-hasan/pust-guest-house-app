<?php

namespace App\Models;

use App\Mail\MailCover;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class AllocationRequest extends Model
{
    use HasFactory;
    protected $appends=['assigned_rooms','report_link','user'];

    public function user():BelongsTo{
        return $this->belongsTo(User::class,'user_id','id');
    }

    public function getUserAttribute(){
        $user=$this->user()->get();
        return [
            'name'=>$user->first()->name,
            'email'=>$user->first()->profile_picture
        ];
    }

    public static function getUniqueHash(){
        return md5(Auth::user()->email.time().uniqid().Auth::id().'##$$');
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

    public function getReportLinkAttribute(){
        try{
            if($this->status=='approved'){
                if($this->token==null){
                    $this->token=self::getUniqueHash();
                    $this->save();
                }
                return route('download-report',[$this->token]);
            }else{
                return null;
            }
        }catch (\Throwable $e){
            return null;
        }
    }

    public static function makeReportHash($alloc_id,$user_id,$user_email,$user_pass){
//        return Hash::make($alloc_id.$user_id.$user_email.$user_pass);
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


    public function save(array $options = [])
    {
        $changed=$this->isDirty()?$this->getDirty():false;
        $save=parent::save($options);
        if($changed){
            $mailData="";
            $mailTitle="";
            foreach ($changed as $key=>$attr){
                if($key=='status'){
                    if($attr=='approved'){
                        $mailTitle="Your Guest House Allocation Request Has been approved.";
                        $mailData="<b>Congratulations</b>, your Allocation Request in ".$this->guest_house()->get()->first()->title." has been <b style='color: green;text-transform: uppercase'>approved</b>. Please Download and Print your PDF copy from the App";
                    }else if ($attr=='rejected'){
                        $mailTitle="Your Guest House Allocation Request is Rejected";
                        $mailData="We have reviewed your application. Unfortunately we have decided to <b style='text-transform:uppercase;color:red'>Rejected</b> your request ";
                        if($this->rejection_reason){
                            $mailData.="for the following reason<br>, \"$this->rejection_reason\".<br>For further query, please contact Guest House Admin";
                        }
                        $mailData.='.';
                    }
                    if($attr=='approved'||$attr=='rejected'){
                        Mail::to($this->user()->get()->first()->email)->send(new MailCover(
                            [
                                'title'=>$mailTitle,
                                'content'=>"<p>$mailData</p>"
                            ]
                        ));
                    }
                }
            }
        }
        return $save;
    }

}
