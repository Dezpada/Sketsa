<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Karya extends Model
{
    use HasFactory;

    protected $table = 'karya';
    protected $fillable = ['user_id', 'judul', 'kode'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
