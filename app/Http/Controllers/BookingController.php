<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use App\Models\AllocationRequest;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Throwable;

class BookingController extends Controller
{


    public function all()
    {
        try {
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => [
                    'allocation' => AllocationRequest::filter(Auth::user()->all_allocation_requests)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.'.$e->getMessage(),
                'code' => 0x07//fetch error
            ];
        }
    }

    public function pending()
    {
        try {
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => ['allocation' => AllocationRequest::filter(Auth::user()->pending_allocation_requests)
                ]
            ];
        }catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x07
            ];
        }
    }

    public function rejected()
    {
        try {
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => ['allocation' => AllocationRequest::filter(Auth::user()->rejected_allocation_requests)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x07
            ];
        }
    }

    public function approved()
    {
        try {
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => ['allocation' => AllocationRequest::filter(Auth::user()->approved_allocation_requests)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x07
            ];
        }
    }

    public function current()
    {
        try {
            return [
                'status' => 'success',
                'message' => 'Request successful',
                'data' => ['allocation' => AllocationRequest::filter(Auth::user()->current_allocation)
                ]
            ];
        } catch (Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x07
            ];
        }
    }

    public function new(Request $request)
    {
        try {
            $data = $request->json()->all();
            $allocation = new AllocationRequest();
            $allocation->fill($data);
            $allocation->user_id = Auth::user()->id;
            $allocation->status = "pending";
            $allocation->save();
            return [
                'status' => 'success',
                'message' => 'New request added.',
                'data' => [
                    'allocation' => $allocation
                ]
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.',
                'code' => 0x07
            ];
        }
    }

    public function update(Request $r)
    {
        try {
            $data = $r->json()->all();
            $alloc = AllocationRequest::filter(AllocationRequest::find($data['id']));
            if ($alloc->user->id != Auth::user()->id) throw new SafeException("You can not modify this allocation");
            if ($alloc->status == "approved") {
                throw new SafeException("Only date extension operation can be performed when your request is approved!");
            }
            unset($data['id']);
            unset($data['user_id']);
            $alloc->fill($data);
            $alloc->status = "pending";
            $alloc->save();
            $alloc = AllocationRequest::filter($alloc);
            $alloc->guest_house;
            return [
                'status' => 'success',
                'message' => 'Allocation updated and waiting for approval.',
                'data' => [
                    'allocation' => $alloc
                ]
            ];
        } catch (SafeException $e) {
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x04
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.",
                'code' => 0x04
            ];
        }
    }

    public function extend(Request $r)
    {
        try {
            $data = $r->json()->all();
            $alloc = AllocationRequest::filter(AllocationRequest::find($data['id']));
            if ($alloc->user->id != Auth::user()->id) throw new SafeException("You can not modify this allocation");
            if ($alloc->status != "approved") {
                throw new SafeException("Only a approved allocation can be requested for date extension!");
            }
            if ($data['extension_request_date'] == null || Carbon::now() > Carbon::parse($data['extension_request_date'])) {
                throw new SafeException("Invalid extension date requested!");
            }
            if (Carbon::parse($data['extension_request_date']) <= Carbon::parse($alloc->departure_date)) {
                throw new SafeException("Current departure date is already enough");
            }
            $alloc->extension_request_date = $data['extension_request_date'];
            $alloc->save();
            $alloc->guest_house;
            return [
                'status' => 'success',
                'message' => 'A extension is requested and waiting for approval.',
                'data' => [
                    'allocation' => $alloc
                ]
            ];
        } catch (SafeException $e) {
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x05
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.",
                'code' => 0x05
            ];
        }
    }


    public function delete(Request $r)
    {
        try {
            $data = $r->json()->all();
            $alloc = AllocationRequest::filter(AllocationRequest::find($data['id']));
            if ($alloc->user->id != Auth::user()->id) throw new SafeException("You can not modify this allocation");
            $alloc->delete();
            return [
                'status' => 'success',
                'message' => 'Allocation has been deleted!',
            ];
        } catch (SafeException $e) {
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x06
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.",
                'code' => 0x06
            ];
        }
    }

}
