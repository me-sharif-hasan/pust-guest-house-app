<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use Illuminate\Http\Request;

class PushNotificationController extends Controller
{
    static public function notify($title, $body, $user){
        try{
            if($user->device_key==null) throw new SafeException("User do not have a valid device key");
            $url = getenv("FCM_API_SERVER");
            $serverKey = env("FCM_SERVER_KEY", 'sync');


            $dataArr=[
                "click_action" => "FLUTTER_NOTIFICATION_CLICK",
                "status" => "done",
            ];

            $data = [
                "registration_ids" => [$user->device_key],
                "notification" => [
                    "title" => $title,
                    "body" => $body,
                    "sound" => "default",
                ],
                "data" => $dataArr,
                "priority" => "high",
            ];

            $encodedData = json_encode($data);

            $headers = [
                "Authorization:key=" . $serverKey,
                "Content-Type: application/json",
            ];

            $ch = curl_init();

            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
            curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
            // Disable ssl certificate support temporary
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
            curl_setopt($ch, CURLOPT_POSTFIELDS, $encodedData);

            $result = curl_exec($ch);

            return [
                'status'=>'success',
                'data'=>$result
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
}
