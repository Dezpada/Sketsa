@extends('layouts.app')
@section('judul', $level->judul)

@section('isi')
<section class="panel">
  <div class="phead">
    <h3>{{ $materi?->judul ?? $level->judul }}</h3>
    <span class="tag">{{ $level->modul->nama }}</span>
  </div>

  <div class="brief">
    {!! $materi?->konten ?? '<p>Materi belum tersedia.</p>' !!}
  </div>

  <div class="aksi">
    <a class="btn utama" href="{{ route('belajar.tantangan', $level) }}">Mulai tantangan</a>
    <a class="btn samar" href="{{ route('belajar.peta') }}">Kembali ke peta</a>
  </div>
</section>
@endsection
