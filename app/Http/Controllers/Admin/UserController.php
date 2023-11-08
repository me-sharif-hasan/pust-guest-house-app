<?php

namespace App\Http\Controllers\Admin;

use App\Exceptions\SafeException;
use App\Http\Controllers\Controller;
use App\Models\Room;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
//error group 1400
class UserController extends Controller
{
    public function list(){
        try {
            $users=User::all();
            return [
                'status'=>'success',
                'message'=>'Users fetched',
                'data'=>[
                    'user'=>$users
                ]
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1401
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Fetching Users failed.',
                'code'=>0x1402
            ];
        }
    }
    public function details(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $user=User::find($data['id']);
            return [
                'status'=>'success',
                'message'=>'User fetched',
                'data'=>[
                    'user'=>$user
                ]
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1403
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Fetching User failed. Is the ID valid?',
                'code'=>0x1404
            ];
        }
    }

    public function update(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $user=User::find($data['id']);
            if(isset($data['profile_picture'])){
                $bin=$data['profile_picture'];
                $image=\Intervention\Image\ImageManagerStatic::make(base64_decode($bin));
                $ext=explode("/",$image->mime)[1];
                $path='/profile-pictures'.uniqid("_dp").'_'.Auth::user()->id.'.'.$ext;
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
                    'code'=>0x1405
                ];
            }else{
                return [
                    'status'=>'error',
                    'message'=>'User profile update failed! Does this user exists?',
                    'code'=>0x1406
                ];
            }
        }
    }

    public function delete(){
        try {
            $data=\request()->json()->all();
            $v=Validator::make($data,[
                'id'=>'required'
            ]);
            if($v->fails()){
                return throw new \LogicException($v->errors()->first());
            }
            $user=User::find($data['id']);
            if($user->user_type=="admin") throw new \LogicException("Admin user can not be deleted");
            $user->delete();
            return [
                'status'=>'success',
                'message'=>'User deleted'
            ];
        }catch (\LogicException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x1407
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'User can not be deleted. Is the ID valid?',
                'code'=>0x1408
            ];
        }
    }
}
