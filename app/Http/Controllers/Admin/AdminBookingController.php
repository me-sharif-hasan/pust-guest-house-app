<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AllocationRequest;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Throwable;

//error group 2
class AdminBookingController extends Controller
{
    public function extensionRequests()
    {
        try {
            $page = \request()->get('page') ? \request()->get('page') : 0;
            $limit = \request()->get('limit') ? \request()->get('limit') : 100000000000;
            $items = AllocationRequest::query()->where('status', '=', 'approved')->where('extension_request_date', '>=', Carbon::now())->simplePaginate($limit, ['*'], 'selected', $page)->items();
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

    public function update(Request $r)
    {
        try {
            $data = $r->json()->all();
            $item = AllocationRequest::filter(AllocationRequest::find($data['id']));
            unset($data['id']);
            $item->fill($data);

            if (isset($data['guest_house_id'])) $item->guest_house_id = $data['guest_house_id'];
            $item->room_id = $data['room_id'] ?? null;
            $item->extension_request_date = $data['extension_request_date'] ?? null;
            if (isset($data['status'])) $item->status = $data['status'];

            $item->save();
            return [
                'status' => 'success',
                'message' => 'Allocation updated!',
                'data' => [
                    'allocation' => AllocationRequest::filter($item)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x203
            ];
        }
    }

    public function all()
    {
        try {
            $page = \request()->get('page') ? \request()->get('page') : 0;
            $limit = \request()->get('limit') ? \request()->get('limit') : 100000000000;
            $items = AllocationRequest::simplePaginate($limit, ['*'], 'selected', $page)->items();
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

    public function delete(Request $r)
    {
        try {
            $data = $r->json()->all();
            $item = AllocationRequest::filter(AllocationRequest::find($data['id']));
            $item->delete();
            return [
                'status' => 'success',
                'message' => 'Allocation deleted!',
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x204
            ];
        }
    }

}
