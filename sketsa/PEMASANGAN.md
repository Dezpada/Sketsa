# Pemasangan Sketsa di Laravel

Berkas dalam arsip ini adalah berkas aplikasi saja, tanpa kerangka Laravel.
Kerangkanya dibuat sendiri di Codespaces karena perlu mengunduh dari internet.

## 1. Membuat project Laravel

Di terminal Codespaces:

```bash
composer create-project laravel/laravel sketsa
cd sketsa
```

## 2. Menyalin berkas ini

Letakkan isi arsip ke dalam folder `sketsa`, menimpa berkas yang sama:

```bash
tar xzf ../sketsa-laravel.tar.gz --strip-components=1 -C .
```

Berkas `routes/web.php` dan `app/Models/User.php` memang menimpa bawaan Laravel.

## 3. Mendaftarkan middleware pengelola

Buka `bootstrap/app.php`, lalu tambahkan alias di dalam `withMiddleware`:

```php
->withMiddleware(function (Middleware $middleware) {
    $middleware->alias([
        'pengelola' => \App\Http\Middleware\PeranPengelola::class,
    ]);
})
```

## 4. Menyiapkan basis data

Laravel 11 ke atas memakai SQLite secara bawaan. Cukup jalankan:

```bash
touch database/database.sqlite
php artisan migrate
php artisan db:seed --class=Database\\Seeders\\SketsaSeeder
```

Bila memakai MySQL, sesuaikan dahulu `.env`.

## 5. Menjalankan

```bash
php artisan serve --host=0.0.0.0 --port=8080
```

Buka port 8080 dari tab PORTS di Codespaces.

## Akun contoh

| Peran | Email | Kata sandi |
| --- | --- | --- |
| Pengelola | pengelola@sketsa.test | password |
| Peserta | peserta@sketsa.test | password |

Ganti kata sandi ini sebelum dipakai di luar pengembangan.

## Isi berkas

| Bagian | Letak |
| --- | --- |
| Migrasi | `database/migrations/` |
| Model | `app/Models/` |
| Mesin penilaian | `app/Services/Penilai.php` |
| Controller peserta | `app/Http/Controllers/BelajarController.php` |
| Controller pengelola | `app/Http/Controllers/Pengelola/` |
| Tampilan | `resources/views/` |
| Aset | `public/css/sketsa.css`, `public/js/tantangan.js` |
| Data contoh | `database/seeders/SketsaSeeder.php` |

## Catatan penting

**Jumlah pemanggilan fungsi dilaporkan oleh peramban.** Aturan
`jumlah_panggil` dan `kanvas_terbentuk` menilai data yang dikirim dari sisi
peserta, sehingga dapat dipalsukan oleh peserta yang memahami cara kerjanya.
Aturan `mengandung_teks` dan `tidak_mengandung` diperiksa langsung pada kode
yang dikirim, sehingga lebih sulit dimanipulasi. Tuliskan keterbatasan ini
pada laporan Tugas Akhir.

**Yang belum tersedia:** papan peringkat antar peserta, lencana, galeri karya,
dan pengelolaan modul atau level lewat antarmuka. Tabelnya sudah ada di
migrasi, tetapi tampilannya belum dibuat.
