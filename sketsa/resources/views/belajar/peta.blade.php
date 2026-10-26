@extends('layouts.app')
@section('judul', 'Peta misi')

@section('isi')
<section class="panel">
  <div class="phead"><h3>Peta misi</h3></div>
  <div class="daftar">
    @foreach ($daftarLevel as $nomor => $level)
      @php
        $sudah = in_array($level->id, $selesai, true);
        $buka = $terbuka[$level->id] ?? false;
        $tantangan = $level->tantangan->first();
      @endphp

      @if ($buka)
        <a class="misi {{ $sudah ? 'selesai' : '' }}" href="{{ route('belajar.materi', $level) }}">
          <i>{{ $sudah ? '✓' : $nomor + 1 }}</i>
          <span>{{ $level->judul }}
            <em>{{ $level->modul->nama }} @if ($tantangan) · {{ $tantangan->namaJenis() }} · {{ $tantangan->xp }} XP @endif</em>
          </span>
        </a>
      @else
        <div class="misi terkunci">
          <i>🔒</i>
          <span>{{ $level->judul }}
            <em>Selesaikan level sebelumnya</em>
          </span>
        </div>
      @endif
    @endforeach
  </div>
</section>
@endsection
