<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

// Halaman utama (publik, tidak perlu login)
Route::get('/', function () {
    return view('jasa.index');
})->name('home');

// Dashboard (harus login)
Route::get('/dashboard', function () {
    $orders = \App\Models\Order::latest();
    if (Illuminate\Support\Facades\Auth::user()->role !== 'admin') {
        $orders->where('user_id', Illuminate\Support\Facades\Auth::id());
    }
    $orders = $orders->get();

    $testimonials = \App\Models\Testimonial::with('user')->latest()->take(6)->get();

    return view('dashboard', compact('orders', 'testimonials'));
})->middleware(['auth', 'verified'])->name('dashboard');

// Public Orders Init (Guests can submit, then login)
Route::post('/order/init', [\App\Http\Controllers\OrderController::class, 'init'])->name('order.init');

// Profile & Order (punya Breeze)
Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    // Orders
    Route::get('/order/data', [\App\Http\Controllers\OrderController::class, 'dataForm'])->name('order.data');
    Route::post('/order/process', [\App\Http\Controllers\OrderController::class, 'process'])->name('order.process');
    Route::get('/order/payment', [\App\Http\Controllers\OrderController::class, 'payment'])->name('order.payment');
    Route::post('/order/confirm', [\App\Http\Controllers\OrderController::class, 'confirmPayment'])->name('order.confirm');
    
    // Testimonials
    Route::post('/testimonials', [\App\Http\Controllers\OrderController::class, 'storeTestimonial'])->name('testimonial.store');

    // Admin Settings
    Route::post('/admin/settings', function (Illuminate\Http\Request $request) {
        if (Illuminate\Support\Facades\Auth::user()->role !== 'admin') abort(403);
        
        $settings = $request->except('_token');
        foreach ($settings as $key => $value) {
            \App\Models\Setting::setVal($key, $value);
        }
        return back()->with('success', 'Harga berhasil diupdate!');
    })->name('admin.settings');
});

// Auth Breeze (login/register/logout)
require __DIR__ . '/auth.php';
