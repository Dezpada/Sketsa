@extends('layouts.app')
@section('judul', $level->judul)

@section('isi')
<div class="area-tantangan {{ $tantangan->jenis === 'koding' ? 'dua-kolom' : '' }}">

  <div class="kolom">
    <section class="panel">
      <div class="phead">
        <h3>{{ $level->judul }}</h3>
        <span class="tag">{{ $tantangan->namaJenis() }} · {{ $tantangan->xp }} XP</span>
      </div>

      <div class="brief"><p>{{ $tantangan->instruksi }}</p></div>

      <div id="isi-soal"
           data-jenis="{{ $tantangan->jenis }}"
           data-kirim="{{ route('belajar.kirim', $level) }}">
        @include('belajar.soal.' . $tantangan->jenis, ['tantangan' => $tantangan])
      </div>

      <div class="aksi">
        <button class="btn utama" id="tombol-kirim">
          {{ $tantangan->jenis === 'koding' ? 'Jalankan' : 'Periksa jawaban' }}
        </button>
        @if ($tantangan->jenis === 'koding')
          <button class="btn samar" id="tombol-reset">Kembalikan kode awal</button>
        @endif
                <a class="btn samar" href="{{ route('belajar.materi', $level) }}">Baca materi lagi</a>
        <a class="btn samar" href="{{ route('belajar.peta') }}">Peta level</a>
      </div>

      <div class="log" id="log-soal" hidden></div>

      <div class="aksi" id="aksi-lanjut" hidden>
        <a class="btn utama" id="tombol-lanjut" href="#"></a>
      </div>

    </section>
  </div>

  @if ($tantangan->jenis === 'koding')
    <section class="panel">
      <div class="phead"><h3>Hasil</h3><span class="tag">iframe sandbox</span></div>
      <div class="panggung">
        <iframe id="panggung" title="Hasil kode" sandbox="allow-scripts"></iframe>
      </div>
      <div class="log" id="log-kode">Tekan Jalankan untuk melihat hasilnya.</div>
    </section>
  @endif

</div>
@endsection

@push('skrip')
<script src="{{ asset('js/tantangan.js') }}"></script>
@endpush
