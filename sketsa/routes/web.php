<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BelajarController;
use App\Http\Controllers\Pengelola\LaporanController;
use App\Http\Controllers\Pengelola\MateriController;
use App\Http\Controllers\Pengelola\TantanganController;
use Illuminate\Support\Facades\Route;

Route::get('/', fn () => redirect()->route('belajar.peta'));

// ---------- autentikasi ----------
Route::middleware('guest')->group(function () {
    Route::get('/masuk', [AuthController::class, 'formMasuk'])->name('masuk');
    Route::post('/masuk', [AuthController::class, 'masuk']);
    Route::get('/daftar', [AuthController::class, 'formDaftar'])->name('daftar');
    Route::post('/daftar', [AuthController::class, 'daftar']);
});

Route::post('/keluar', [AuthController::class, 'keluar'])->middleware('auth')->name('keluar');

// ---------- peserta ----------
Route::middleware('auth')->group(function () {
    Route::get('/belajar', [BelajarController::class, 'peta'])->name('belajar.peta');
    Route::get('/belajar/{level}/materi', [BelajarController::class, 'materi'])->name('belajar.materi');
    Route::get('/belajar/{level}/tantangan', [BelajarController::class, 'tantangan'])->name('belajar.tantangan');
    Route::post('/belajar/{level}/kirim', [BelajarController::class, 'kirim'])->name('belajar.kirim');
});

// ---------- pengelola ----------
Route::middleware(['auth', 'pengelola'])->prefix('pengelola')->name('pengelola.')->group(function () {
    Route::get('/materi', [MateriController::class, 'index'])->name('materi.index');
    Route::get('/level/{level}/materi/baru', [MateriController::class, 'create'])->name('materi.create');
    Route::post('/level/{level}/materi', [MateriController::class, 'store'])->name('materi.store');
    Route::get('/materi/{materi}/ubah', [MateriController::class, 'edit'])->name('materi.edit');
    Route::put('/materi/{materi}', [MateriController::class, 'update'])->name('materi.update');
    Route::delete('/materi/{materi}', [MateriController::class, 'destroy'])->name('materi.destroy');

    Route::get('/level/{level}/tantangan', [TantanganController::class, 'edit'])->name('tantangan.edit');
    Route::put('/level/{level}/tantangan', [TantanganController::class, 'update'])->name('tantangan.update');

    Route::get('/laporan', [LaporanController::class, 'index'])->name('laporan');
});
