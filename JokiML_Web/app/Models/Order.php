<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $fillable = [
        'user_id',
        'jasa_id',
        'type',
        'paket_name',
        'from_rank',
        'to_rank',
        'from_star',
        'to_star',
        'price',
        'status',
        'payment_status',
        'payment_proof',
        'customer_name',
        'game_id',
        'moonton_account',
        'moonton_password',
        'hero_request',
        'whatsapp'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function jasa()
    {
        return $this->belongsTo(Jasa::class);
    }
}
