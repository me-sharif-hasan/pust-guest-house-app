<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use App\Models\User;
use Illuminate\Http\Request;

class BulkSMSBDController extends Controller
{
    public static function sendSMS($text,User $user){
        try{
            $phone=$user->phone;
            if($phone==null||$phone=="") throw new SafeException("User do not have a phone number");
            $smsGateWayKey=getenv("BULKSMSBD_API_KEY");
            $smsSenderID=getenv("BULKSMSBD_SENDER_ID");
            $text=urlencode($text);
            $url="http://bulksmsbd.net/api/smsapi?api_key=$smsGateWayKey&type=text&number=$phone&senderid=$smsSenderID&message=$text";
            $data=file_get_contents($url);
            $data=json_decode($data,true);
            return [
                'status'=>'success',
                'data'=>$data
            ];
        }catch (SafeException $e){
            return [
                'status'=>'error',
                'message'=>$e->getMessage()
            ];
        }catch (\Throwable $e){
            return [
                'status'=>'error',
                'message'=>'Something went wrong'
            ];
        }
    }


    public function get_balance() {
        $url = "https://bulksmsbd.net/api/getBalanceApi";
        $api_key = getenv("BULKSMSBD_API_KEY");
        $data = [
            "api_key" => $api_key
        ];
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $response = curl_exec($ch);
        curl_close($ch);
        return $response;
    }

}
