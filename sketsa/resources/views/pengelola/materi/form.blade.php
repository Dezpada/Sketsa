@extends('layouts.app')
@section('judul', 'Materi')

@section('isi')
<section class="panel">
  <div class="phead">
    <h3>{{ $materi->exists ? 'Ubah materi' : 'Materi baru' }}</h3>
    <span class="tag">{{ $level->judul }}</span>
  </div>

  <form method="POST"
        action="{{ $materi->exists ? route('pengelola.materi.update', $materi) : route('pengelola.materi.store', $level) }}"
        class="form">
    @csrf
    @if ($materi->exists) @method('PUT') @endif

    <label>Judul
      <input type="text" name="judul" value="{{ old('judul', $materi->judul) }}" required>
    </label>

    <label>Konten (boleh memuat tag HTML sederhana seperti &lt;p&gt;, &lt;code&gt;, &lt;pre&gt;)
      <textarea name="konten" required>{{ old('konten', $materi->konten) }}</textarea>
    </label>

    <label>Urutan
      <input type="number" name="urutan" value="{{ old('urutan', $materi->urutan ?? 1) }}" min="1" required>
    </label>

    @foreach ($errors->all() as $pesan)
      <p class="galat">{{ $pesan }}</p>
    @endforeach

    <div class="aksi">
      <button class="btn utama">Simpan</button>
      <a class="btn samar" href="{{ route('pengelola.materi.index') }}">Batal</a>
    </div>
  </form>

  @if ($materi->exists)
    <form method="POST" action="{{ route('pengelola.materi.destroy', $materi) }}" class="form"
          onsubmit="return confirm('Hapus materi ini?')">
      @csrf @method('DELETE')
      <div class="aksi"><button class="btn samar">Hapus materi</button></div>
    </form>
  @endif
</section>
@endsection
