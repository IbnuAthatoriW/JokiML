<?php
// app/Http/Controllers/Api/TestimonialApiController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Testimonial;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TestimonialApiController extends Controller
{
    public function index()
    {
        $testimonials = Testimonial::with('user:id,name')->latest()->take(20)->get();
        return response()->json($testimonials);
    }

    public function store(Request $request)
    {
        $request->validate([
            'content' => 'required|string|max:500',
            'rating' => 'required|integer|min:1|max:5',
        ]);

        $testimonial = Testimonial::create([
            'user_id' => Auth::id(),
            'content' => $request->content,
            'rating' => $request->rating,
        ]);

        // Reload user relationship
        $testimonial->load('user:id,name');

        return response()->json([
            'message' => 'Review submitted successfully',
            'testimonial' => $testimonial
        ], 201);
    }

    public function destroy(Testimonial $testimonial)
    {
        if (Auth::user()->role !== 'admin' && Auth::id() !== $testimonial->user_id) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        $testimonial->delete();

        return response()->json([
            'message' => 'Testimonial deleted successfully'
        ]);
    }

    public function reply(Request $request, Testimonial $testimonial)
    {
        if (Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $request->validate([
            'reply' => 'required|string|max:500'
        ]);

        $testimonial->update(['reply' => $request->reply]);

        // Reload user relationship
        $testimonial->load('user:id,name');

        return response()->json([
            'message' => 'Reply sent successfully',
            'testimonial' => $testimonial
        ]);
    }
}
