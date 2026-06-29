<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Jasa;
use App\Services\RankingSystem;
use App\Services\RankCalculator;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class OrderController extends Controller
{
    public function index()
    {
        // Admin sees all orders, user sees their own
        if (Auth::user()->role === 'admin') {
            $orders = Order::latest()->get();
        } else {
            $orders = Order::where('user_id', Auth::id())->latest()->get();
        }
        return view('order.index', compact('orders'));
    }

    public function init(Request $request)
    {
        $request->validate([
            'type' => 'required|in:paket,custom',
            'price' => 'required|numeric|min:1',
            'paket_name' => 'nullable|string',
            'from_rank' => 'nullable|string',
            'to_rank' => 'nullable|string',
            'from_star' => 'nullable|numeric|min:0|max:9999',
            'to_star' => 'nullable|numeric|min:0|max:9999',
        ]);

        // Validasi untuk custom order
        if ($request->type === 'custom') {
            $fromRank = $request->input('from_rank');
            $toRank = $request->input('to_rank');
            $fromStar = (int)$request->input('from_star');
            $toStar = (int)$request->input('to_star');

            // Validasi rank ada
            if (!$fromRank || !$toRank) {
                return back()->withErrors(['rank' => 'Pilih rank awal dan tujuan']);
            }

            // Validasi rank valid
            $allRanks = RankingSystem::getAllRanks();
            if (!in_array($fromRank, $allRanks) || !in_array($toRank, $allRanks)) {
                return back()->withErrors(['rank' => 'Rank tidak valid']);
            }

            // Validasi star sesuai dengan range rank
            if (!RankingSystem::validateStarInRank($fromRank, $fromStar)) {
                $range = RankingSystem::getStarRange($fromRank);
                return back()->withErrors(['from_star' => "Bintang untuk {$fromRank} harus antara {$range['min']} sampai {$range['max']}"]);
            }

            if (!RankingSystem::validateStarInRank($toRank, $toStar)) {
                $range = RankingSystem::getStarRange($toRank);
                return back()->withErrors(['to_star' => "Bintang untuk {$toRank} harus antara {$range['min']} sampai {$range['max']}"]);
            }
        }

        $request->session()->put('order_init', $request->except('_token'));
        
        if (!Auth::check()) {
            session()->put('url.intended', route('order.data'));
            return redirect()->route('login');
        }
        
        return redirect()->route('order.data');
    }

    public function dataForm(Request $request)
    {
        if (!$request->session()->has('order_init')) {
            return redirect()->route('home');
        }
        
        $orderData = $request->session()->get('order_init');
        return view('order.data', compact('orderData'));
    }

    public function process(Request $request)
    {
        if (!$request->session()->has('order_init')) {
            return redirect()->route('home');
        }
        $orderData = $request->session()->get('order_init');

        $validated = $request->validate([
            'customer_name' => 'required|string|max:255',
            'game_id' => 'required|string|max:255',
            'moonton_account' => 'required|string|max:255',
            'moonton_password' => 'required|string|max:255',
            'hero_request' => 'nullable|string|max:255',
            'whatsapp' => 'required|string|max:20',
        ]);

        $finalData = array_merge($orderData, $validated);
        $request->session()->put('order_final', $finalData);

        return redirect()->route('order.payment');
    }

    public function payment(Request $request)
    {
        if (!$request->session()->has('order_final')) {
            return redirect()->route('home');
        }
        $orderData = $request->session()->get('order_final');
        return view('order.payment', compact('orderData'));
    }

    public function confirmPayment(Request $request)
    {
        if (!$request->session()->has('order_final')) {
            return redirect()->route('home');
        }

        $request->validate([
            'payment_proof' => 'required|image|mimes:jpeg,jpg,png,webp|max:5120',
        ], [
            'payment_proof.required' => 'Bukti pembayaran wajib diupload!',
            'payment_proof.image' => 'File harus berupa gambar!',
            'payment_proof.mimes' => 'Format gambar harus jpeg, jpg, png, atau webp!',
            'payment_proof.max' => 'Ukuran gambar maksimal 5MB!',
        ]);

        $data = $request->session()->get('order_final');

        // Upload payment proof
        $proofPath = $request->file('payment_proof')->store('payment_proofs', 'public');

        $order = Order::create([
            'user_id' => Auth::id(),
            'type' => $data['type'],
            'paket_name' => $data['paket_name'] ?? null,
            'from_rank' => $data['from_rank'] ?? null,
            'to_rank' => $data['to_rank'] ?? null,
            'from_star' => $data['from_star'] ?? null,
            'to_star' => $data['to_star'] ?? null,
            'price' => $data['price'],
            'status' => 'pending',
            'payment_status' => 'sudah dibayar',
            'payment_proof' => $proofPath,
            'customer_name' => $data['customer_name'],
            'game_id' => $data['game_id'],
            'moonton_account' => $data['moonton_account'],
            'moonton_password' => $data['moonton_password'],
            'hero_request' => $data['hero_request'],
            'whatsapp' => $data['whatsapp'],
        ]);
        
        $request->session()->forget('order_init');
        $request->session()->forget('order_final');

        return redirect()->route('order.invoice', $order->id)->with('success', 'Pembayaran berhasil! Berikut adalah nota pemesanan Anda.');
    }

    public function invoice(Order $order)
    {
        // Only allow the order owner or admin to view
        if (Auth::user()->role !== 'admin' && Auth::id() !== $order->user_id) {
            abort(403);
        }

        return view('order.invoice', compact('order'));
    }

    public function storeTestimonial(Request $request)
    {
        $request->validate([
            'content' => 'required|string|max:500',
            'rating' => 'required|integer|min:1|max:5',
        ]);

        \App\Models\Testimonial::create([
            'user_id' => Auth::id(),
            'content' => $request->input('content'),
            'rating' => $request->input('rating'),
        ]);

        return back()->with('success', 'Terima kasih atas ulasan Anda!');
    }

    public function updateStatus(Request $request, Order $order)
    {
        if (Auth::user()->role !== 'admin') {
            abort(403);
        }

        $request->validate([
            'status' => 'required|in:pending,on progress,selesai',
        ]);

        $order->update(['status' => $request->status]);

        return back()->with('success', 'Status order berhasil diupdate!');
    }

    public function destroyTestimonial(\App\Models\Testimonial $testimonial)
    {
        if (Auth::user()->role !== 'admin' && Auth::id() !== $testimonial->user_id) {
            abort(403);
        }
        $testimonial->delete();
        return back()->with('success', 'Testimoni berhasil dihapus!');
    }

    public function replyTestimonial(Request $request, \App\Models\Testimonial $testimonial)
    {
        if (Auth::user()->role !== 'admin') {
            abort(403);
        }
        $request->validate([
            'reply' => 'required|string|max:500'
        ]);
        $testimonial->update(['reply' => $request->reply]);
        return back()->with('success', 'Balasan berhasil dikirim!');
    }

    /**
     * Calculate price for custom rank order with multi-rank support
     * This is called from the frontend (mobile/web) to calculate real-time pricing
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
            $fromStar = (int)$request->input('from_star');
            $toRank = $request->input('to_rank');
            $toStar = (int)$request->input('to_star');
            $pricePerRank = $request->input('price_per_rank');

            // Validate rank-star combinations
            if (!RankingSystem::validateStarInRank($fromRank, $fromStar)) {
                return response()->json([
                    'success' => false,
                    'error' => "Bintang {$fromStar} tidak valid untuk rank {$fromRank}"
                ], 422);
            }

            if (!RankingSystem::validateStarInRank($toRank, $toStar)) {
                return response()->json([
                    'success' => false,
                    'error' => "Bintang {$toStar} tidak valid untuk rank {$toRank}"
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

