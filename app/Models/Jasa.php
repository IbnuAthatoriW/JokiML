<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Jasa extends Model
{
    protected $fillable = [
        'nama_jasa',
        'deskripsi',
        'harga'
    ];

    public function orders()
    {
        return $this->hasMany(Order::class);
    }
}
