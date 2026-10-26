@extends('layouts.app')
@section('judul', 'Kelola materi')

@section('isi')
<section class="panel">
  <div class="phead"><h3>Materi dan tantangan</h3></div>
  <table>
    <thead>
      <tr><th>Level</th><th>Modul</th><th>Materi</th><th>Tantangan</th><th></th></tr>
    </thead>
    <tbody>
      @foreach ($daftarLevel as $level)
        @php $tantangan = $level->tantangan->first(); @endphp
        <tr>
          <td>{{ $level->urutan }}. {{ $level->judul }}</td>
          <td>{{ $level->modul->nama }}</td>
          <td>
            @forelse ($level->materi as $materi)
              <a href="{{ route('pengelola.materi.edit', $materi) }}">{{ $materi->judul }}</a><br>
            @empty
              <span style="color:var(--ink-2)">belum ada</span><br>
            @endforelse
            <a href="{{ route('pengelola.materi.create', $level) }}">+ tambah materi</a>
          </td>
          <td>
            @if ($tantangan)
              {{ $tantangan->namaJenis() }} · {{ $tantangan->xp }} XP
            @else
              <span style="color:var(--ink-2)">belum ada</span>
            @endif
          </td>
          <td><a class="btn samar" href="{{ route('pengelola.tantangan.edit', $level) }}">Atur tantangan</a></td>
        </tr>
      @endforeach
    </tbody>
  </table>
</section>
@endsection
