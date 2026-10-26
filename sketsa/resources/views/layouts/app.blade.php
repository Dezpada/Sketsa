<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="csrf-token" content="{{ csrf_token() }}">
<title>@yield('judul', 'Sketsa')</title>
<link rel="stylesheet" href="{{ asset('css/sketsa.css') }}">
</head>
<body>

<header class="bar">
  <div class="brand">
    <b>Sketsa</b>
    <span>belajar koding lewat visual</span>
  </div>

  @auth
    @if (auth()->user()->pengelola())
      <nav class="menu">
        <a href="{{ route('pengelola.materi.index') }}">Materi</a>
        <a href="{{ route('pengelola.laporan') }}">Laporan</a>
      </nav>
    @else
      <nav class="menu">
        <a href="{{ route('belajar.peta') }}">Peta level</a>
      </nav>
      <div class="stat">

        <span class="lvl">{{ auth()->user()->levelGamifikasi() }}</span>
        <div class="xpwrap">
          <div class="xptrack"><div class="xpfill" style="width: {{ auth()->user()->total_xp % 100 }}%"></div></div>
          <div class="xpnum" id="xp-num">{{ auth()->user()->total_xp }} XP</div>
        </div>
      </div>
    @endif

    <form method="POST" action="{{ route('keluar') }}">
      @csrf
      <button class="btn samar">Keluar</button>
    </form>
  @endauth
</header>

<main class="wrap">
  @if (session('pesan'))
    <div class="kabar">{{ session('pesan') }}</div>
  @endif

  @yield('isi')
</main>

<div class="pop" id="pop" role="status" aria-live="polite"></div>
@stack('skrip')
</body>
</html>
