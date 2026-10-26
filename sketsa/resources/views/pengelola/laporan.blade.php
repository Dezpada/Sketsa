@extends('layouts.app')
@section('judul', 'Laporan')

@section('isi')
<section class="panel">
  <div class="phead"><h3>Perkembangan peserta</h3></div>
  <table>
    <thead><tr><th>Peserta</th><th>Level selesai</th><th>Total XP</th><th>Level gamifikasi</th></tr></thead>
    <tbody>
      @forelse ($peserta as $orang)
        <tr>
          <td>{{ $orang->name }}</td>
          <td>{{ $orang->level_selesai }}</td>
          <td>{{ $orang->total_xp }}</td>
          <td>{{ $orang->levelGamifikasi() }}</td>
        </tr>
      @empty
        <tr><td colspan="4" style="color:var(--ink-2)">Belum ada peserta.</td></tr>
      @endforelse
    </tbody>
  </table>
</section>

<section class="panel">
  <div class="phead">
    <h3>Tantangan yang paling sering gagal</h3>
    <span class="tag">dasar evaluasi materi</span>
  </div>
  <table>
    <thead><tr><th>Level</th><th>Bentuk</th><th>Percobaan</th><th>Gagal</th><th>Persentase gagal</th></tr></thead>
    <tbody>
      @forelse ($kesulitan as $baris)
        <tr>
          <td>{{ $baris->tantangan->level->judul }}</td>
          <td>{{ $baris->tantangan->namaJenis() }}</td>
          <td>{{ $baris->percobaan }}</td>
          <td>{{ $baris->gagal }}</td>
          <td>{{ $baris->persen }}%</td>
        </tr>
      @empty
        <tr><td colspan="5" style="color:var(--ink-2)">Belum ada percobaan.</td></tr>
      @endforelse
    </tbody>
  </table>
</section>
@endsection
