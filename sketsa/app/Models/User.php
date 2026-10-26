<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasFactory, Notifiable;

    protected $fillable = ['name', 'email', 'password', 'peran', 'total_xp', 'avatar'];

    protected $hidden = ['password', 'remember_token'];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function progres()
    {
        return $this->hasMany(Progres::class);
    }

    public function percobaan()
    {
        return $this->hasMany(Percobaan::class);
    }

    public function karya()
    {
        return $this->hasMany(Karya::class);
    }

    public function lencana()
    {
        return $this->belongsToMany(Lencana::class, 'lencana_pengguna', 'user_id', 'lencana_id')
            ->withPivot('diperoleh_pada')
            ->withTimestamps();
    }

    public function pengelola(): bool
    {
        return $this->peran === 'pengelola';
    }

    public function levelGamifikasi(): int
    {
        return intdiv($this->total_xp, 100) + 1;
    }
}
