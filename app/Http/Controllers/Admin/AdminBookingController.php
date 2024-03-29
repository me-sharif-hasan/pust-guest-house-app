<?php

namespace App\Http\Controllers\Admin;

use App\Exceptions\SafeException;
use App\Http\Controllers\Controller;
use App\Models\AllocationRequest;
use App\Models\Room;
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

//            $item->is_user_seen=0;
//            $item->is_admin_seen=0;

            if (isset($data['guest_house_id'])) $item->guest_house_id = $data['guest_house_id'];

            if(isset($data['room_id'])){
                if(!is_array($data['room_id'])) throw new SafeException("Assigned room id must be an list");
                $rooms=[];
                foreach ($data['room_id'] as $r){
                    $pr=Room::find($r);
                    if($pr->beds&&count($pr->beds)==0){
                        $rooms[]=$pr->id;
                    }else{
                        foreach ($pr->beds as $bed){
                            $rooms[]=$bed->id;
                        }
                    }
                }
                $rooms=array_unique($rooms);
                $item->room()->detach();
                $item->room()->attach($rooms);
            }
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
                'message' => 'Something went wrong.'.$e->getMessage(),
                'code' => 0x203
            ];
        }
    }

    public function all()
    {
        try {
            $page = \request()->get('page') ? \request()->get('page') : 0;
            $limit = \request()->get('limit') ? \request()->get('limit') : 100000000000;
            $stat = \request()->get('status') ??null;
            $pages = AllocationRequest::where(function ($q) use($stat){
                if($stat!=null){
                    return $q->where('status','=',$stat);
                }else{
                    return $q;
                }
            })->orderByDesc('id')->paginate($limit, ['*'], 'selected', $page);
            $totalPage=ceil($pages->total()/$limit);
            $items=$pages->items();
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => [
                    'num_page'=>$totalPage,
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
