<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class VerficationCheckMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    //error group 2000
    public function handle(Request $request, Closure $next): Response
    {
        if($request->user()->hasVerifiedEmail()){
            return $next($request);
        }else{
            return \response()->json([
                'status'=>'not-verified',
                'message'=>"Email is not verified!",
                'code'=>0x2001
            ]);
        }

    }
}
