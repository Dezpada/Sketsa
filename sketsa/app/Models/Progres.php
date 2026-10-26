<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Progres extends Model
{
    use HasFactory;

    protected $table = 'progres';
    protected $fillable = ['user_id', 'level_id', 'status', 'xp_diperoleh', 'selesai_pada'];
    protected $casts = ['selesai_pada' => 'datetime'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function level()
    {
        return $this->belongsTo(Level::class);
    }
}
