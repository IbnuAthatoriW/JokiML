<?php
// app/Http/Controllers/Api/OrderApiController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Services\RankingSystem;
use App\Services\RankCalculator;
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
            'from_star' => 'nullable|integer|min:0',
            'to_star' => 'nullable|integer|min:0',
            'customer_name' => 'required|string|max:255',
            'game_id' => 'required|string|max:255',
            'moonton_account' => 'required|string|max:255',
            'moonton_password' => 'required|string|max:255',
            'hero_request' => 'nullable|string|max:255',
            'whatsapp' => 'required|string|max:20',
            'payment_proof' => 'required|image|mimes:jpeg,jpg,png,webp|max:5120',
        ]);

        // Validasi untuk custom order
        if ($request->type === 'custom') {
            $fromRank = $request->input('from_rank');
            $toRank = $request->input('to_rank');
            $fromStar = (int) $request->input('from_star');
            $toStar = (int) $request->input('to_star');

            // Validasi rank ada
            if (!$fromRank || !$toRank) {
                return response()->json([
                    'message' => 'Pilih rank awal dan tujuan untuk custom order',
                    'errors' => ['rank' => 'Rank harus dipilih']
                ], 422);
            }

            // Validasi rank valid
            $allRanks = RankingSystem::getAllRanks();
            if (!in_array($fromRank, $allRanks) || !in_array($toRank, $allRanks)) {
                return response()->json([
                    'message' => 'Rank tidak valid',
                    'errors' => ['rank' => 'Rank tidak tersedia dalam sistem']
                ], 422);
            }

            // Validasi star sesuai dengan range rank
            if (!RankingSystem::validateStarInRank($fromRank, $fromStar)) {
                $range = RankingSystem::getStarRange($fromRank);
                return response()->json([
                    'message' => sprintf(
                        '%s hanya menerima bintang %d sampai %d',
                        $fromRank,
                        $range['min'],
                        $range['max']
                    ),
                    'errors' => ['from_star' => "Bintang harus antara {$range['min']} sampai {$range['max']}"]
                ], 422);
            }

            if (!RankingSystem::validateStarInRank($toRank, $toStar)) {
                $range = RankingSystem::getStarRange($toRank);
                return response()->json([
                    'message' => sprintf(
                        '%s hanya menerima bintang %d sampai %d',
                        $toRank,
                        $range['min'],
                        $range['max']
                    ),
                    'errors' => ['to_star' => "Bintang harus antara {$range['min']} sampai {$range['max']}"]
                ], 422);
            }
        }
        $pricePerRank = $request->input('price_per_rank') ?? [];

        if ($request->type === 'custom') {
            RankCalculator::calculatePrice(
                $request->input('from_rank'),
                (int)$request->input('from_star'),
                $request->input('to_rank'),
                (int)$request->input('to_star'),
                $pricePerRank
            );
        }

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

    /**
     * Calculate price for custom rank order with multi-rank support
     */
    public function calculateCustomPrice(Request $request)
    {
        try {
            $request->validate([
                'from_rank' => 'required|string',
                'from_star' => 'required|integer|min:0',
                'to_rank' => 'required|string',
                'to_star' => 'required|integer|min:0',
                'price_per_rank' => 'required|array',
            ]);

            $fromRank = $request->input('from_rank');
            $fromStar = (int) $request->input('from_star');
            $toRank = $request->input('to_rank');
            $toStar = (int) $request->input('to_star');
            $pricePerRank = $request->input('price_per_rank');

            // Validate rank-star combinations
            if (!RankingSystem::validateStarInRank($fromRank, $fromStar)) {
                return response()->json([
                    'success' => false,
                    'error' => "Bintang {$fromStar} tidak valid untuk rank {$fromRank}"
                ], 422);
            }

            if (!RankingSystem::validateStarInRank($toRank, $toStar)) {

                $range = RankingSystem::getStarRange($toRank);

                return response()->json([
                    'success' => false,
                    'error' => sprintf(
                        '%s hanya menerima bintang %d sampai %d',
                        $toRank,
                        $range['min'],
                        $range['max']
                    )
                ], 422);
            }

            // Calculate price with breakdown
            $priceData = RankCalculator::calculatePrice(
                $fromRank,
                $fromStar,
                $toRank,
                $toStar,
                $pricePerRank
            );

            return response()->json([
                'success' => true,
                'total_price' => $priceData['total_price'],
                'breakdown' => $priceData['breakdown'],
            ]);
        } catch (\InvalidArgumentException $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get all valid ranks and their star ranges
     */
    public function getRankInfo(Request $request)
    {
        $ranks = [];
        foreach (RankingSystem::getAllRanks() as $rankName) {
            $details = RankingSystem::getRankDetails($rankName);
            $ranges = RankingSystem::getStarRange($rankName);
            $ranks[] = [
                'name' => $rankName,
                'min_star' => $ranges['min'],
                'max_star' => $ranges['max'],
            ];
        }

        return response()->json([
            'success' => true,
            'ranks' => $ranks,
        ]);
    }
}
