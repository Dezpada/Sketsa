<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tantangan extends Model
{
    use HasFactory;

    protected $table = 'tantangan';
    protected $fillable = ['level_id', 'jenis', 'instruksi', 'kode_awal', 'xp', 'urutan'];

    public const JENIS = ['pilihan_ganda', 'drag_drop', 'koding'];

    public function level()
    {
        return $this->belongsTo(Level::class);
    }

    public function item()
    {
        return $this->hasMany(TantanganItem::class)->orderBy('urutan_tampil');
    }

    public function aturan()
    {
        return $this->hasMany(TantanganAturan::class)->orderBy('urutan');
    }

    public function percobaan()
    {
        return $this->hasMany(Percobaan::class);
    }

    public function namaJenis(): string
    {
        return match ($this->jenis) {
            'pilihan_ganda' => 'Pilihan ganda',
            'drag_drop' => 'Susun urutan',
            default => 'Menulis kode',
        };
    }
}
