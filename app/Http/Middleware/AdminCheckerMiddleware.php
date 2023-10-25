<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class AdminCheckerMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        //error group 3
        if(Auth::user()->user_type=="admin"){
            return $next($request);
        }else{
            return \response()->json([
                'status'=>'error',
                'message'=>'You are not authorised to perform this operation',
                'code'=>0x301
            ]);
        }
    }
}
