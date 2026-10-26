<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Modul extends Model
{
    use HasFactory;

    protected $table = 'modul';
    protected $fillable = ['nama', 'urutan'];

    public function level()
    {
        return $this->hasMany(Level::class)->orderBy('urutan');
    }
}
