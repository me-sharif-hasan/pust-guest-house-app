<?php

namespace App\Http\Controllers;

use App\Exceptions\SafeException;
use App\Models\AccessToken;
use App\Models\AllocationRequest;
use Barryvdh\DomPDF\Facade\Pdf;
use Carbon\Carbon;
use Dompdf\Dompdf;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Throwable;
//error group 4
class BookingController extends Controller
{


    public function all()
    {
        $a=AllocationRequest::find(4);
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
                'code' => 0x401//fetch error
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
                'code' => 0x402
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
                'code' => 0x403
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
                'code' => 0x404
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
                'code' => 0x405
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
            $allocation->token=AllocationRequest::getUniqueHash();
            $allocation->save();
            return [
                'status' => 'success',
                'message' => 'New request added.',
                'data' => [
                    'allocation' => AllocationRequest::filter($allocation)
                ]
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => 'Something went wrong.'.$e->getMessage(),
                'code' => 0x406
            ];
        }
    }

    public function update(Request $r)
    {
        try {
            $data = $r->json()->all();
            $alloc = AllocationRequest::filter(AllocationRequest::find($data['id']));
            if ($alloc->user->id != Auth::user()->id) throw new SafeException("You can not modify this allocation");
            if ($alloc->status == "approved"&&!(isset($data['status'])&&($data['status']=='cancelled'||$data['status']=='rejected'))) {
                if(isset($data['is_user_seen'])){
                    $alloc->is_user_seen=$data['is_user_seen'];
                    $alloc->save();
                }else{
                    throw new SafeException("Only date extension operation can be performed when your request is approved!");
                }
            }else{
                unset($data['id']);
                unset($data['user_id']);
                if(isset($data['rejection_reason'])) throw new SafeException("You can not change rejection reason. This permission is only for admin!");
                $alloc->fill($data);
                $alloc->status = (isset($data['status'])&&($data['status']=='cancelled'||$data['status']=='rejected'))||$alloc->status=='rejected'?$data['status']??$alloc->status:"pending";
                $alloc->save();
                $alloc = AllocationRequest::filter($alloc);
                $alloc->guest_house;
            }

            return [
                'status' => 'success',
                'message' => $alloc->status=='cancelled'||$alloc->status=='rejected'?'Allocation updated':'Allocation updated and waiting for approval.',
                'data' => [
                    'allocation' => $alloc
                ]
            ];
        } catch (SafeException $e) {
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x407
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.".$e->getMessage(),
                'code' => 0x408
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
                'code' => 0x409
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.",
                'code' => 0x410
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
                'code' => 0x411
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.",
                'code' => 0x412
            ];
        }
    }

    public function cancelExtend(Request $r){
        try {
            $data = $r->json()->all();
            $alloc = AllocationRequest::filter(AllocationRequest::find($data['id']));
            if ($alloc->user->id != Auth::user()->id) throw new SafeException("You can not modify this allocation");

            if($alloc->extension_request_date==null) throw new SafeException("Invalid request");
            $alloc->extension_request_date=null;
            $alloc->save();
            return [
                'status' => 'success',
                'message' => 'Extension request has been cancelled',
                'data'=>['allocation'=>$alloc]
            ];
        } catch (SafeException $e) {
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x413
            ];
        } catch (\Throwable $e) {
            return [
                'status' => 'error',
                'message' => "Something went wrong.",
                'code' => 0x414
            ];
        }
    }

    public function download($token,$return_view=false){
        try{
            $at=AllocationRequest::where('token','=',$token)->get();
            if(count($at)==0) throw new SafeException("The link you are following is not valid");
            $id=$at->first()->id;
            $allocation=AllocationRequest::find($id);
            if(!$id) throw new SafeException("No allocation with that ID");
            if($allocation->status!='approved') throw new SafeException("Only approved allocation PDF can be downloaded");
            $vw=view('report')->with('allocation',$allocation);
            $html=$vw->render();
            $pdf=new Dompdf();
            $pdf->loadHtml($html);
            $pdf->render();
            $out=$pdf->output();
            return response()->streamDownload(function() use ($out){
               echo $out;
            },$allocation->guest_house->first()->title." allocation report.pdf");
        }catch (SafeException $e){
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x415
            ];
        }catch (Throwable $e){
            return [
                'status' => 'error',
                'message' => $e->getMessage(),
                'code' => 0x416
            ];
        }
    }

}
