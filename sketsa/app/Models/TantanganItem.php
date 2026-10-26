<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TantanganItem extends Model
{
    use HasFactory;

    protected $table = 'tantangan_item';
    protected $fillable = ['tantangan_id', 'konten', 'benar', 'urutan_benar', 'urutan_tampil'];
    protected $casts = ['benar' => 'boolean'];

    public function tantangan()
    {
        return $this->belongsTo(Tantangan::class);
    }
}
