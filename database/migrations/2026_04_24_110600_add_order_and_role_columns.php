<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('user')->after('password');
        });

        Schema::table('orders', function (Blueprint $table) {
            $table->string('type')->default('paket')->after('user_id'); // paket, custom
            $table->string('paket_name')->nullable()->after('type');
            $table->string('from_rank')->nullable()->after('paket_name');
            $table->string('to_rank')->nullable()->after('from_rank');
            $table->integer('from_star')->nullable()->after('to_rank');
            $table->integer('to_star')->nullable()->after('from_star');
            $table->integer('price')->default(0)->after('to_star');
            $table->string('payment_status')->default('unpaid')->after('status');
        });
        
        // Make jasa_id nullable
        Schema::table('orders', function (Blueprint $table) {
            $table->foreignId('jasa_id')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('role');
        });

        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['type', 'paket_name', 'from_rank', 'to_rank', 'from_star', 'to_star', 'price', 'payment_status']);
            $table->foreignId('jasa_id')->nullable(false)->change();
        });
    }
};
