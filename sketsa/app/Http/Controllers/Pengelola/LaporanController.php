<?php

namespace App\Http\Controllers\Pengelola;

use App\Http\Controllers\Controller;
use App\Models\Percobaan;
use App\Models\Tantangan;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class LaporanController extends Controller
{
    public function index()
    {
        $peserta = User::where('peran', 'peserta')
            ->withCount(['progres as level_selesai' => fn ($q) => $q->where('status', 'selesai')])
            ->orderByDesc('total_xp')
            ->get();

        // Tantangan yang paling sering gagal menjadi dasar evaluasi materi.
        $kesulitan = Tantangan::with('level')
            ->get()
            ->map(function (Tantangan $t) {
                $semua = Percobaan::where('tantangan_id', $t->id)->count();
                $gagal = Percobaan::where('tantangan_id', $t->id)->where('benar', false)->count();

                return (object) [
                    'tantangan' => $t,
                    'percobaan' => $semua,
                    'gagal' => $gagal,
                    'persen' => $semua > 0 ? round($gagal / $semua * 100) : 0,
                ];
            })
            ->sortByDesc('persen');

        return view('pengelola.laporan', [
            'peserta' => $peserta,
            'kesulitan' => $kesulitan,
        ]);
    }
}
