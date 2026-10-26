<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Level extends Model
{
    use HasFactory;

    protected $table = 'level';
    protected $fillable = ['modul_id', 'judul', 'urutan'];

    public function modul()
    {
        return $this->belongsTo(Modul::class);
    }

    public function materi()
    {
        return $this->hasMany(Materi::class)->orderBy('urutan');
    }

    public function tantangan()
    {
        return $this->hasMany(Tantangan::class)->orderBy('urutan');
    }

    public function progres()
    {
        return $this->hasMany(Progres::class);
    }
}
