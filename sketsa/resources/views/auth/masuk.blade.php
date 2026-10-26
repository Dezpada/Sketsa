@extends('layouts.app')
@section('judul', 'Masuk')

@section('isi')
<section class="panel sempit">
  <div class="phead"><h3>Masuk</h3></div>
  <form method="POST" action="{{ route('masuk') }}" class="form">
    @csrf
    <label>Email
      <input type="email" name="email" value="{{ old('email') }}" required autofocus>
    </label>
    <label>Kata sandi
      <input type="password" name="password" required>
    </label>

    @error('email') <p class="galat">{{ $message }}</p> @enderror

    <div class="aksi">
      <button class="btn utama">Masuk</button>
      <a class="btn samar" href="{{ route('daftar') }}">Daftar</a>
    </div>
  </form>
</section>
@endsection
