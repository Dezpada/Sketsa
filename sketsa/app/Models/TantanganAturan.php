<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TantanganAturan extends Model
{
    use HasFactory;

    protected $table = 'tantangan_aturan';
    protected $fillable = [
        'tantangan_id', 'jenis_aturan', 'target', 'cakupan',
        'operator', 'nilai', 'pesan_gagal', 'urutan',
    ];

    public const JENIS_ATURAN = [
        'kanvas_terbentuk' => 'Kanvas harus terbentuk',
        'mengandung_teks' => 'Kode harus memuat teks',
        'tidak_mengandung' => 'Kode tidak boleh memuat teks',
        'jumlah_panggil' => 'Jumlah pemanggilan fungsi',
    ];

    public function tantangan()
    {
        return $this->belongsTo(Tantangan::class);
    }
}
