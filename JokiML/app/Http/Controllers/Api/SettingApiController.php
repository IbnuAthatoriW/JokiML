<?php
// app/Http/Controllers/Api/SettingApiController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class SettingApiController extends Controller
{
    public function index()
    {
        $settings = [
            'price_gm_epic' => (int) Setting::getVal('price_gm_epic', 60000),
            'price_epic_legend' => (int) Setting::getVal('price_epic_legend', 100000),
            'price_legend_mythic' => (int) Setting::getVal('price_legend_mythic', 150000),

            'star_grandmaster' => (int) Setting::getVal('star_grandmaster', 3000),
            'star_epic' => (int) Setting::getVal('star_epic', 4000),
            'star_legend' => (int) Setting::getVal('star_legend', 6000),
            'star_mythic' => (int) Setting::getVal('star_mythic', 9000),
            'star_honor' => (int) Setting::getVal('star_honor', 13000),
            'star_glory' => (int) Setting::getVal('star_glory', 30000),
            'star_immortal' => (int) Setting::getVal('star_immortal', 100000),
        ];

        return response()->json($settings);
    }

    public function update(Request $request)
    {
        if (Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized. Admin role required.'], 403);
        }

        $validated = $request->validate([
            'price_gm_epic' => 'nullable|integer|min:0',
            'price_epic_legend' => 'nullable|integer|min:0',
            'price_legend_mythic' => 'nullable|integer|min:0',
            'star_grandmaster' => 'nullable|integer|min:0',
            'star_epic' => 'nullable|integer|min:0',
            'star_legend' => 'nullable|integer|min:0',
            'star_mythic' => 'nullable|integer|min:0',
            'star_honor' => 'nullable|integer|min:0',
            'star_glory' => 'nullable|integer|min:0',
            'star_immortal' => 'nullable|integer|min:0',
        ]);

        foreach ($validated as $key => $value) {
            if ($value !== null) {
                Setting::setVal($key, $value);
            }
        }

        return response()->json([
            'message' => 'Settings updated successfully',
            'settings' => $this->index()->original
        ]);
    }
}
