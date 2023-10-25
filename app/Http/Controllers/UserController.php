<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function update(Request $r){
        try {
            $data=$r->json()->all();
            $user=Auth::user();
            $user->fill($data);
            $user->save();
            return [
                'status'=>'success',
                'message'=>'Profile updated!',
                'data'=>[
                    'user'=>$user
                ]
            ];
        }catch (\Throwable $e){
            if($e instanceof SafeException){
                return [
                    'status'=>'error',
                    'message'=>$e->getMessage(),
                    'code'=>0x02
                ];
            }else{
                return [
                    'status'=>'error',
                    'message'=>'User profile update failed!',
                    'code'=>0x02
                ];
            }
        }
    }
}
