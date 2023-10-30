<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Mockery\Exception;

//error group 5
class UserLoginAndRegistrationController extends Controller
{
    public function login(Request $request){
        try{
            $data=$request->json()->all();
            if(Auth::attempt(['email'=>$data['email'],'password'=>$data['password']])){
                $token=$request->user()->createToken($request->user()->email);
                return [
                    'status'=>'success',
                    'message'=>'Login successful',
                    'data'=>[
                        'token'=>$token->plainTextToken
                    ]
                ];
            }else throw new Exception('Login failed!');
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Login failed',
                'code'=>0x501,
            ];
        }
    }

    public function registration(Request $request){
        try{
            $data=$request->json()->all();
            $isValid=validator($data,[
                'password'=>'required|min:6',
                'name'=>'required',
                'email'=>'required|ends_with:pust.ac.bd',
                'department'=>'required',
                'title'=>'required',
                ''
            ]);
            if($isValid->errors()->first()) throw new SafeException($isValid->errors()->first());
            $user=new User();
            $user->fill($data);
            $user->save();
            return [
                'status'=>'success',
                'message'=>'Registration successful',
                'data'=>[
                    'user'=>$user
                ]
            ];
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x502,
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>"Registration failed. Something went wrong".$e->getMessage(),
                'code'=>0x503,
            ];
        }
    }
}
