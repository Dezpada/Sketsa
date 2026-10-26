@extends('layouts.app')
@section('judul', 'Daftar')

@section('isi')
<section class="panel sempit">
  <div class="phead"><h3>Daftar sebagai peserta</h3></div>
  <form method="POST" action="{{ route('daftar') }}" class="form">
    @csrf
    <label>Nama
      <input type="text" name="name" value="{{ old('name') }}" required autofocus>
    </label>
    <label>Email
      <input type="email" name="email" value="{{ old('email') }}" required>
    </label>
    <label>Kata sandi
      <input type="password" name="password" required>
    </label>
    <label>Ulangi kata sandi
      <input type="password" name="password_confirmation" required>
    </label>

    @foreach ($errors->all() as $pesan)
      <p class="galat">{{ $pesan }}</p>
    @endforeach

    <div class="aksi">
      <button class="btn utama">Daftar</button>
      <a class="btn samar" href="{{ route('masuk') }}">Sudah punya akun</a>
    </div>
  </form>
</section>
@endsection
