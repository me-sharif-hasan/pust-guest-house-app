<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use App\Mail\MailCover;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Mockery\Exception;
use Psy\Util\Str;

//error group 5
class UserLoginAndRegistrationController extends Controller
{
    public function login(Request $request){
        try{
            $data=$request->json()->all();
            if(Auth::attempt(['email'=>$data['email'],'password'=>$data['password']])){
                $token=$request->user()->createToken($request->user()->email);
                $ret=[
                    'status'=>'success',
                    'message'=>'Login successful',
                    'data'=>[
                        'token'=>$token->plainTextToken
                    ]
                ];

                if(!Auth::user()->hasVerifiedEmail()){
                    $ret['status']='not_verified';
                    $ret['message']='Please verify your account.';
                }
                return $ret;
            }else throw new SafeException('Username or Password might be wrong');
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x501,
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Login failed'.$e->getMessage(),
                'code'=>0x502,
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
            if(Auth::attempt(['email'=>$data['email'],'password'=>$data['password']])&&$this->sendVerificationCode()){
                $token=$request->user()->createToken($request->user()->email);
                return [
                    'status'=>'success',
                    'message'=>'Registration successful. Check your email for the verification code',
                    'data'=>[
                        'token'=>$token->plainTextToken,
                        'user'=>$user
                    ]
                ];
            }else{
                $user->delete();
                throw new SafeException("User was created but sending verification code failed. Hence user is deleted again. Please try again.");
            }

        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x503,
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>"Registration failed. Something went wrong",
                'code'=>0x504,
            ];
        }
    }

    public function verify(){
        try {
            $code=\request()->json()->all()['code'];
            if(Auth::user()->verification_code==$code){
                Auth::user()->verification_code=null;
                Auth::user()->email_verified_at=now();
                Auth::user()->save();
                return [
                    'status'=>'success',
                    'message'=>'Account verified!'
                ];
            }else{
                throw new SafeException("Wrong verification code");
            }
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x505
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Something went wrong',
                'code'=>0x506
            ];
        }
    }

    public function resend(){
        try {
            if($this->sendVerificationCode()){
                return [
                    'status'=>'success',
                    'message'=>'A verification code is been sent to your email.'
                ];
            }else{
                throw new SafeException("Sending verification code failed!");
            }
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x507
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Something went wrong',
                'code'=>0x508
            ];
        }
    }
    public function sendVerificationCode($user=null){
        try{
            $user=$user??Auth::user();
            $vcode=strtoupper(uniqid());
            $email=$user->email;
            $user->verification_code=$vcode;
            $user->save();
            Mail::to($email)->send(new MailCover(
                [
                    'title'=>'PUST Guest House Email Verification',
                    'code'=>$vcode
                ]
            ));
            return true;
        }catch (\Throwable $e){
            echo $e->getMessage();
            return false;
        }
    }
}
