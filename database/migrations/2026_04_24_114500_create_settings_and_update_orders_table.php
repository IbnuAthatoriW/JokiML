<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('settings', function (Blueprint $table) {
            $table->id();
            $table->string('key')->unique();
            $table->text('value')->nullable();
            $table->timestamps();
        });

        Schema::table('orders', function (Blueprint $table) {
            $table->string('game_id')->nullable()->after('price');
            $table->string('moonton_account')->nullable()->after('game_id');
            $table->string('moonton_password')->nullable()->after('moonton_account');
            $table->string('hero_request')->nullable()->after('moonton_password');
            $table->string('whatsapp')->nullable()->after('hero_request');
            $table->string('customer_name')->nullable()->after('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('settings');
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['game_id', 'moonton_account', 'moonton_password', 'hero_request', 'whatsapp', 'customer_name']);
        });
    }
};
