<?php

namespace App\Http\Controllers\Pengelola;

use App\Http\Controllers\Controller;
use App\Models\Level;
use App\Models\Tantangan;
use Illuminate\Http\Request;

class TantanganController extends Controller
{
    public function edit(Level $level)
    {
        $tantangan = $level->tantangan()->with(['item', 'aturan'])->first()
            ?? new Tantangan(['level_id' => $level->id, 'jenis' => 'pilihan_ganda', 'xp' => 20, 'urutan' => 1]);

        return view('pengelola.tantangan.form', [
            'level' => $level,
            'tantangan' => $tantangan,
        ]);
    }

    public function update(Request $request, Level $level)
    {
        $data = $request->validate([
            'jenis' => ['required', 'in:pilihan_ganda,drag_drop,koding'],
            'instruksi' => ['required', 'string'],
            'kode_awal' => ['nullable', 'string'],
            'xp' => ['required', 'integer', 'min:0'],

            'item' => ['nullable', 'array'],
            'item.*.konten' => ['required_with:item', 'string'],
            'item.*.benar' => ['nullable', 'boolean'],
            'item.*.urutan_benar' => ['nullable', 'integer', 'min:1'],

            'aturan' => ['nullable', 'array'],
            'aturan.*.jenis_aturan' => ['required_with:aturan', 'in:kanvas_terbentuk,mengandung_teks,tidak_mengandung,jumlah_panggil'],
            'aturan.*.target' => ['nullable', 'string'],
            'aturan.*.cakupan' => ['nullable', 'in:setup,draw,semua'],
            'aturan.*.operator' => ['nullable', 'in:=,>=,<='],
            'aturan.*.nilai' => ['nullable', 'integer'],
            'aturan.*.pesan_gagal' => ['required_with:aturan', 'string'],
        ]);

        $tantangan = $level->tantangan()->first();

        if ($tantangan) {
            $tantangan->update([
                'jenis' => $data['jenis'],
                'instruksi' => $data['instruksi'],
                'kode_awal' => $data['kode_awal'] ?? null,
                'xp' => $data['xp'],
            ]);
        } else {
            $tantangan = $level->tantangan()->create([
                'jenis' => $data['jenis'],
                'instruksi' => $data['instruksi'],
                'kode_awal' => $data['kode_awal'] ?? null,
                'xp' => $data['xp'],
                'urutan' => 1,
            ]);
        }

        $this->simpanItem($tantangan, $data);
        $this->simpanAturan($tantangan, $data);

        return redirect()->route('pengelola.materi.index')->with('pesan', 'Tantangan disimpan.');
    }

    protected function simpanItem(Tantangan $tantangan, array $data): void
    {
        $tantangan->item()->delete();

        if ($tantangan->jenis === 'koding') {
            return;
        }

        foreach (array_values($data['item'] ?? []) as $i => $baris) {
            $tantangan->item()->create([
                'konten' => $baris['konten'],
                'benar' => $tantangan->jenis === 'pilihan_ganda' ? (bool) ($baris['benar'] ?? false) : null,
                'urutan_benar' => $tantangan->jenis === 'drag_drop' ? ($baris['urutan_benar'] ?? $i + 1) : null,
                'urutan_tampil' => $i + 1,
            ]);
        }
    }

    protected function simpanAturan(Tantangan $tantangan, array $data): void
    {
        $tantangan->aturan()->delete();

        if ($tantangan->jenis !== 'koding') {
            return;
        }

        foreach (array_values($data['aturan'] ?? []) as $i => $baris) {
            $tantangan->aturan()->create([
                'jenis_aturan' => $baris['jenis_aturan'],
                'target' => $baris['target'] ?? null,
                'cakupan' => $baris['cakupan'] ?? null,
                'operator' => $baris['operator'] ?? null,
                'nilai' => $baris['nilai'] ?? null,
                'pesan_gagal' => $baris['pesan_gagal'],
                'urutan' => $i + 1,
            ]);
        }
    }
}
