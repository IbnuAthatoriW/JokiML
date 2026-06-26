<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\SettingApiController;
use App\Http\Controllers\Api\TestimonialApiController;
use App\Http\Controllers\Api\OrderApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::get('/settings', [SettingApiController::class, 'index']);
Route::get('/testimonials', [TestimonialApiController::class, 'index']);

// Ranking system endpoints
Route::get('/ranks', [OrderApiController::class, 'getRankInfo']);
Route::post('/orders/calculate-price', [OrderApiController::class, 'calculateCustomPrice']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);
    Route::post('/settings', [SettingApiController::class, 'update']);

    Route::post('/testimonials', [TestimonialApiController::class, 'store']);
    Route::delete('/testimonials/{testimonial}', [TestimonialApiController::class, 'destroy']);
    Route::post('/testimonials/{testimonial}/reply', [TestimonialApiController::class, 'reply']);

    Route::get('/orders', [OrderApiController::class, 'index']);
    Route::post('/orders', [OrderApiController::class, 'store']);
    Route::patch('/orders/{order}/status', [OrderApiController::class, 'updateStatus']);
});
