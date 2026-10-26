<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Percobaan extends Model
{
    use HasFactory;

    protected $table = 'percobaan';
    protected $fillable = ['user_id', 'tantangan_id', 'jawaban', 'benar', 'pesan', 'xp_diperoleh'];
    protected $casts = ['jawaban' => 'array', 'benar' => 'boolean'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function tantangan()
    {
        return $this->belongsTo(Tantangan::class);
    }
}
