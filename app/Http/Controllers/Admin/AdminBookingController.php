<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AllocationRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Throwable;
//error group 2
class AdminBookingController extends Controller
{
    public function all(){
        try {
            $page=\request()->get('page')?\request()->get('page'):0;
            $limit=\request()->get('limit')?\request()->get('limit'):100000000000;
            $items=AllocationRequest::simplePaginate($limit,['*'],'selected',$page)->items();
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => [
                    'allocation' => AllocationRequest::filter($items)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x201//fetch error
            ];
        }
    }

    public function pending(){
        try {
            $page=\request()->get('page')?\request()->get('page'):0;
            $limit=\request()->get('limit')?\request()->get('limit'):100000000000;
            $items=AllocationRequest::query()->where('status','=','pending')->simplePaginate($limit,['*'],'selected',$page)->items();
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => [
                    'allocation' => AllocationRequest::filter($items)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x202//fetch error
            ];
        }
    }
}
