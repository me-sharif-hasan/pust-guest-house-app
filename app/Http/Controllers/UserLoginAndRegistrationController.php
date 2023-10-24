<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Mockery\Exception;

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
                'code'=>0x01,
            ];
        }
    }
}
