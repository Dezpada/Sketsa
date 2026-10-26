<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Materi extends Model
{
    use HasFactory;

    protected $table = 'materi';
    protected $fillable = ['level_id', 'judul', 'konten', 'urutan'];

    public function level()
    {
        return $this->belongsTo(Level::class);
    }
}
