<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use App\Mail\MailCover;
use App\Models\PasswordResetCodes;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

//error group 5000
class PasswordResetCodesController extends Controller
{
    public function sendCode(){
        try {
            $data=\request()->json()->all();
            $isValid=validator($data,[
                'email'=>'required|ends_with:pust.ac.bd',
            ]);
            if($isValid->errors()->first()) throw new SafeException($isValid->errors()->first());
            $user=User::where('email','=',$data['email'])->get();
            if(!$user||!$user->first()){
                throw new SafeException("No user have been found with that specific email");
            }
            $user=$user->first();
            $code=PasswordResetCodes::where('email','=',$user->email)?->first()??new PasswordResetCodes();
            $code->email=$user->email;
            $code->code=strtoupper(uniqid());
            $code->attempt=0;
            $code->save();
            $email=$code->email;
            Mail::to($email)->send(new MailCover(
                [
                    'title'=>'PUST Guest House app password reset tokens',
                    'content'=>"Your password reset code is: <b>".$code->code."</b>.<br>Please use this code to rest your password.<br><u>Do not share this code with anybody else.</u>"
                ]
            ));
            return [
                'status'=>'success',
                'message'=>'A verification code has been just sent to your email. Please use this code to be able to reset your password',
            ];
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x5001
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Something went wrong'.$e->getMessage(),
                'code'=>0x5002
            ];
        }
    }

    public function verify(){
        try {
            $data=\request()->json()->all();
            $isValid=validator($data,[
                'email'=>'required|ends_with:pust.ac.bd',
                'code'=>'required'
            ]);
            if($isValid->errors()->first()) throw new SafeException($isValid->errors()->first());
            $user=User::where('email','=',$data['email'])->get();
            if(!$user||!$user->first()){
                throw new SafeException("No user have been found with that specific email");
            }
            $user=$user->first();
            $code=PasswordResetCodes::where('email','=',$user->email)?->first();

            if(!$code) throw new SafeException("Invalid password reset request. Code verification failed");
            if($code->code!=$data['code']){
                if($code->attempt>=6){
                    $code->delete();
                    throw new SafeException("Limit of your reset token expired. Please request again");
                }
                $code->attempt++;
                $code->save();
                throw new SafeException("Password verification code mismatch");
            };
            return [
                'status'=>'success',
                'message'=>'Code is verified! Please send new password',
            ];
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x5003
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Something went wrong'.$e->getMessage(),
                'code'=>0x5004
            ];
        }
    }

    public function reset(){
        try {
            $v=$this->verify()['status'];
            if($v=='error'){
                throw new SafeException($v['message']);
            }
            $data=\request()->json()->all();
            if(!isset($data['password'])||$data['password']==null||strlen($data['password']<6)){
                throw new SafeException("Length of the password must be greater than or equal 6 character");
            }
            $user=User::where('email','=',$data['email'])->first();
            if(!$user) throw new SafeException("User does not exists");
            $user->password=$data['password'];
            $user->save();
            $code=PasswordResetCodes::where('email','=',$user->email)?->first()?->delete();
            $user->tokens()->delete();
            return [
                'status'=>'success',
                'message'=>'Password reset successful'
            ];
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage(),
                'code'=>0x5005
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>"Something went wrong",
                'code'=>0x5006
            ];
        }
    }

}
