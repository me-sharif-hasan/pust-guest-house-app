<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Nette\Utils\Image;

class UserController extends Controller
{
    public function update(Request $r){
        try {
            $data=$r->json()->all();
            $user=Auth::user();
            if(isset($data['profile_picture'])){
                $bin=$data['profile_picture'];
                $image=\Intervention\Image\ImageManagerStatic::make(base64_decode($bin));
                $ext=explode("/",$image->mime)[1];
                $dir=public_path('profile-pictures');
                $path=$dir.'/'.uniqid("_dp").'_'.Auth::user()->id.'.'.$ext;
                $image->save($path);
            }
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
                    'message'=>'User profile update failed!'.$e->getMessage(),
                    'code'=>0x02
                ];
            }
        }
    }
}
