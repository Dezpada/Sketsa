<?php

namespace App\Http\Controllers;

use App\Models\Level;
use App\Models\Percobaan;
use App\Models\Progres;
use App\Models\User;
use App\Services\Penilai;
use Illuminate\Http\Request;

class BelajarController extends Controller
{
    public function __construct(protected Penilai $penilai)
    {
    }

    public function peta(Request $request)
    {
        $level = Level::with('modul', 'tantangan')
            ->orderBy('urutan')
            ->get();

        $selesai = $this->levelSelesai($request->user());

        return view('belajar.peta', [
            'daftarLevel' => $level,
            'selesai' => $selesai,
            'terbuka' => $this->levelTerbuka($level, $selesai),
        ]);
    }

    public function materi(Request $request, Level $level)
    {
        abort_unless($this->bolehMasuk($request->user(), $level), 403, 'Selesaikan level sebelumnya terlebih dahulu.');

        return view('belajar.materi', [
            'level' => $level->load('materi'),
            'materi' => $level->materi->first(),
        ]);
    }

    public function tantangan(Request $request, Level $level)
    {
        abort_unless($this->bolehMasuk($request->user(), $level), 403, 'Selesaikan level sebelumnya terlebih dahulu.');

        $tantangan = $level->tantangan()->with('item')->first();
        abort_unless($tantangan, 404, 'Level ini belum memiliki tantangan.');

        return view('belajar.tantangan', [
            'level' => $level,
            'tantangan' => $tantangan,
        ]);
    }

    public function kirim(Request $request, Level $level)
    {
        abort_unless($this->bolehMasuk($request->user(), $level), 403);

        $tantangan = $level->tantangan()->with(['item', 'aturan'])->firstOrFail();
        $pengguna = $request->user();

        $jawaban = $request->validate([
            'item_id' => ['nullable', 'integer'],
            'urutan' => ['nullable', 'array'],
            'urutan.*' => ['integer'],
            'kode' => ['nullable', 'string'],
            'total' => ['nullable', 'array'],
            'setelah_setup' => ['nullable', 'array'],
            'ada_kanvas' => ['nullable', 'boolean'],
        ]);

        $hasil = $this->penilai->nilai($tantangan, $jawaban);
        $sudahSelesai = $this->sudahSelesai($pengguna, $level);
        $xp = ($hasil['lulus'] && ! $sudahSelesai) ? $tantangan->xp : 0;

        Percobaan::create([
            'user_id' => $pengguna->id,
            'tantangan_id' => $tantangan->id,
            'jawaban' => $jawaban,
            'benar' => $hasil['lulus'],
            'pesan' => $hasil['pesan'],
            'xp_diperoleh' => $xp,
        ]);

        if ($hasil['lulus'] && ! $sudahSelesai) {
            $this->catatKelulusan($pengguna, $level, $xp);
        }

        return response()->json([
            'lulus' => $hasil['lulus'],
            'pesan' => $hasil['pesan'],
            'xp_diperoleh' => $xp,
            'total_xp' => $pengguna->fresh()->total_xp,
        'lanjut' => $hasil['lulus'] ? $this->tujuanBerikut($level) : null,
        ]);
    }

    protected function tujuanBerikut(Level $level): array
    {
        $berikut = Level::where('urutan', '>', $level->urutan)
            ->orderBy('urutan')
            ->first();

        if(! $berikut){
            return [
                'url' => route('belajar.peta'),
                'label' => 'Semua level selesai - lihat peta',
            ];
        }

        return [
            'url' => route('belajar.materi', $berikut),
            'label' => 'Lanjut ke level ' . $berikut->urutan . ': ' . $berikut->judul,
        ];
    }

    protected function catatKelulusan(User $pengguna, Level $level, int $xp): void
    {
        Progres::updateOrCreate(
            ['user_id' => $pengguna->id, 'level_id' => $level->id],
            ['status' => 'selesai', 'xp_diperoleh' => $xp, 'selesai_pada' => now()]
        );

        $pengguna->increment('total_xp', $xp);
    }

    protected function sudahSelesai(User $pengguna, Level $level): bool
    {
        return Progres::where('user_id', $pengguna->id)
            ->where('level_id', $level->id)
            ->where('status', 'selesai')
            ->exists();
    }

    protected function levelSelesai(?User $pengguna): array
    {
        if (! $pengguna) {
            return [];
        }

        return Progres::where('user_id', $pengguna->id)
            ->where('status', 'selesai')
            ->pluck('level_id')
            ->all();
    }

    /** Level terbuka bila level sebelumnya sudah diselesaikan. */
    protected function levelTerbuka($daftarLevel, array $selesai): array
    {
        $terbuka = [];
        $sebelumnya = null;

        foreach ($daftarLevel as $level) {
            $terbuka[$level->id] = $sebelumnya === null || in_array($sebelumnya, $selesai, true);
            $sebelumnya = $level->id;
        }

        return $terbuka;
    }

    protected function bolehMasuk(?User $pengguna, Level $level): bool
    {
        $daftar = Level::orderBy('urutan')->get();
        $terbuka = $this->levelTerbuka($daftar, $this->levelSelesai($pengguna));

        return $terbuka[$level->id] ?? false;
    }
}
