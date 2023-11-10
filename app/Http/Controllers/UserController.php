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
                $storage_dir='/profile-pictures/';
                if(!is_dir(public_path($storage_dir))){
                    mkdir(public_path($storage_dir));
                }
                $path=$storage_dir.uniqid("_dp").'_'.Auth::user()->id.'.'.$ext;
                $image->save(public_path($path));
                $user->profile_picture=$path;
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
                    'message'=>'User profile update failed!',
                    'code'=>0x02
                ];
            }
        }
    }
}
