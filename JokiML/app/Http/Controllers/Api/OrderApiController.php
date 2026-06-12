<?php
// app/Http/Controllers/Api/OrderApiController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class OrderApiController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        
        if ($user->role === 'admin') {
            $orders = Order::with('user:id,name,email')->latest()->get();
        } else {
            $orders = Order::where('user_id', $user->id)->latest()->get();
        }

        return response()->json($orders);
    }

    public function store(Request $request)
    {
        $request->validate([
            'type' => 'required|in:paket,custom',
            'price' => 'required|numeric|min:1',
            'paket_name' => 'nullable|string',
            'from_rank' => 'nullable|string',
            'to_rank' => 'nullable|string',
            'from_star' => 'nullable|integer',
            'to_star' => 'nullable|integer',
            'customer_name' => 'required|string|max:255',
            'game_id' => 'required|string|max:255',
            'moonton_account' => 'required|string|max:255',
            'moonton_password' => 'required|string|max:255',
            'hero_request' => 'nullable|string|max:255',
            'whatsapp' => 'required|string|max:20',
            'payment_proof' => 'required|image|mimes:jpeg,jpg,png,webp|max:5120',
        ]);

        // Store payment proof file
        $proofPath = $request->file('payment_proof')->store('payment_proofs', 'public');

        $order = Order::create([
            'user_id' => Auth::id(),
            'type' => $request->type,
            'paket_name' => $request->paket_name,
            'from_rank' => $request->from_rank,
            'to_rank' => $request->to_rank,
            'from_star' => $request->from_star,
            'to_star' => $request->to_star,
            'price' => $request->price,
            'status' => 'pending',
            'payment_status' => 'sudah dibayar',
            'payment_proof' => $proofPath,
            'customer_name' => $request->customer_name,
            'game_id' => $request->game_id,
            'moonton_account' => $request->moonton_account,
            'moonton_password' => $request->moonton_password,
            'hero_request' => $request->hero_request,
            'whatsapp' => $request->whatsapp,
        ]);

        return response()->json([
            'message' => 'Order created successfully',
            'order' => $order
        ], 201);
    }

    public function updateStatus(Request $request, Order $order)
    {
        if (Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $request->validate([
            'status' => 'required|in:pending,on progress,selesai',
        ]);

        $order->update(['status' => $request->status]);

        return response()->json([
            'message' => 'Order status updated successfully',
            'order' => $order
        ]);
    }
}
