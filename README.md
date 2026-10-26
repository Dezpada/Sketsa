# Sketsa — purwarupa aplikasi pembelajaran koding

Purwarupa untuk Tugas Akhir. Setiap level menyajikan materi terlebih dahulu,
kemudian tantangan. Tantangan tersedia dalam tiga bentuk: pilihan ganda,
penyusunan langkah, dan penulisan kode dengan p5.js.

Tujuan purwarupa ini adalah **menguji rancangan basis data sebelum dibangun di
Laravel**. Karena itu `data.js` disusun persis seperti tabel yang akan dibuat.

## Cara menjalankan

Di terminal Codespaces:

```bash
python3 -m http.server 8080
```

Buka port 8080 lewat notifikasi yang muncul, atau lewat tab **PORTS**.

## Isi berkas

| Berkas | Isi |
| --- | --- |
| `index.html` | Kerangka halaman |
| `style.css` | Tampilan |
| `data.js` | **Pengganti basis data.** Semua materi, tantangan, dan aturan penilaian |
| `app.js` | Mesin aplikasi: alur, penilaian, gamifikasi |

## Struktur data

`data.js` memuat enam kumpulan yang setara dengan tabel basis data:

| Kumpulan | Keterangan |
| --- | --- |
| `modul` | Pengelompokan level |
| `level` | Satuan pembelajaran, punya urutan |
| `materi` | Bacaan yang tampil sebelum tantangan |
| `tantangan` | Satu per level, punya kolom `jenis` |
| `tantangan_item` | Pilihan jawaban (pilihan ganda) atau langkah (susun urutan) |
| `tantangan_aturan` | Kriteria penilaian khusus tantangan koding |

## Aturan penilaian tantangan koding

Kriteria penilaian berbentuk **data**, bukan kode. Inilah yang nanti diisi
pengelola melalui formulir di Laravel.

| `jenis_aturan` | Kolom yang dipakai | Arti |
| --- | --- | --- |
| `kanvas_terbentuk` | — | Kode harus menghasilkan kanvas |
| `mengandung_teks` | `target` | Kode harus memuat teks tertentu |
| `tidak_mengandung` | `target` | Kode tidak boleh memuat teks tertentu |
| `jumlah_panggil` | `target`, `cakupan`, `operator`, `nilai` | Jumlah pemanggilan fungsi harus sesuai |

Kolom `cakupan` bernilai `setup`, `draw`, atau `semua`, untuk membedakan
pemanggilan yang terjadi saat persiapan dan saat animasi berjalan.

Setiap aturan punya `pesan_gagal`, yaitu umpan balik yang ditampilkan kepada
peserta bila aturan tersebut tidak terpenuhi. Aturan diperiksa berurutan, dan
pemeriksaan berhenti pada aturan pertama yang gagal.

Contoh aturan untuk misi "Jembatan tiga pilar":

| jenis_aturan | target | cakupan | operator | nilai |
| --- | --- | --- | --- | --- |
| kanvas_terbentuk | — | — | — | — |
| mengandung_teks | `for` | — | — | — |
| jumlah_panggil | `rect` | setup | = | 4 |

## Menambah level baru

Tambahkan satu baris pada `level`, satu pada `materi`, satu pada `tantangan`,
lalu isi `tantangan_item` atau `tantangan_aturan` sesuai jenisnya. Tidak perlu
mengubah `app.js`.

## Catatan

Kode peserta dijalankan di dalam `iframe` ber-`sandbox`, terpisah dari halaman
utama.

Progres disimpan di `localStorage`. Pada aplikasi sebenarnya bagian ini diganti
pemanggilan API ke Laravel — lihat `muatProgres()` dan `simpanProgres()`.

Purwarupa ini belum mencakup antarmuka pengelola, akun pengguna, papan
peringkat antar pengguna, dan galeri karya.
