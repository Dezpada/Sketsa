<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Lencana extends Model
{
    use HasFactory;

    protected $table = 'lencana';
    protected $fillable = ['nama', 'keterangan', 'level_id'];

    public function pengguna()
    {
        return $this->belongsToMany(User::class, 'lencana_pengguna', 'lencana_id', 'user_id')
            ->withPivot('diperoleh_pada')
            ->withTimestamps();
    }
}
