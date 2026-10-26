<?php

namespace App\Http\Controllers\Pengelola;

use App\Http\Controllers\Controller;
use App\Models\Level;
use App\Models\Materi;
use Illuminate\Http\Request;

class MateriController extends Controller
{
    public function index()
    {
        return view('pengelola.materi.index', [
            'daftarLevel' => Level::with('modul', 'materi', 'tantangan')->orderBy('urutan')->get(),
        ]);
    }

    public function create(Level $level)
    {
        return view('pengelola.materi.form', [
            'level' => $level,
            'materi' => new Materi(['level_id' => $level->id, 'urutan' => 1]),
        ]);
    }

    public function store(Request $request, Level $level)
    {
        $data = $this->validasi($request);
        $data['level_id'] = $level->id;
        Materi::create($data);

        return redirect()->route('pengelola.materi.index')->with('pesan', 'Materi ditambahkan.');
    }

    public function edit(Materi $materi)
    {
        return view('pengelola.materi.form', [
            'level' => $materi->level,
            'materi' => $materi,
        ]);
    }

    public function update(Request $request, Materi $materi)
    {
        $materi->update($this->validasi($request));

        return redirect()->route('pengelola.materi.index')->with('pesan', 'Materi diperbarui.');
    }

    public function destroy(Materi $materi)
    {
        $materi->delete();

        return redirect()->route('pengelola.materi.index')->with('pesan', 'Materi dihapus.');
    }

    protected function validasi(Request $request): array
    {
        return $request->validate([
            'judul' => ['required', 'string', 'max:255'],
            'konten' => ['required', 'string'],
            'urutan' => ['required', 'integer', 'min:1'],
        ]);
    }
}
