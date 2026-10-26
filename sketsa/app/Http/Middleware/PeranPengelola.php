<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class PeranPengelola
{
    public function handle(Request $request, Closure $next): Response
    {
        if (! $request->user() || ! $request->user()->pengelola()) {
            abort(403, 'Halaman ini hanya untuk pengelola.');
        }

        return $next($request);
    }
}
