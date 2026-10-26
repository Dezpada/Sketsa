<?php

namespace Database\Seeders;

use App\Models\Level;
use App\Models\Modul;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class SketsaSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'pengelola@sketsa.test'],
            ['name' => 'Pengelola Komunitas', 'password' => Hash::make('password'), 'peran' => 'pengelola']
        );

        User::updateOrCreate(
            ['email' => 'peserta@sketsa.test'],
            ['name' => 'Peserta Contoh', 'password' => Hash::make('password'), 'peran' => 'peserta']
        );

        foreach ($this->isi() as $urutan => $baris) {
            $modul = Modul::updateOrCreate(['nama' => $baris['modul']], ['urutan' => $urutan + 1]);

            $level = Level::updateOrCreate(
                ['modul_id' => $modul->id, 'judul' => $baris['judul']],
                ['urutan' => $urutan + 1]
            );

            $level->materi()->delete();
            $level->materi()->create([
                'judul' => $baris['materi_judul'],
                'konten' => $baris['materi'],
                'urutan' => 1,
            ]);

            $level->tantangan()->delete();
            $tantangan = $level->tantangan()->create([
                'jenis' => $baris['jenis'],
                'instruksi' => $baris['instruksi'],
                'kode_awal' => $baris['kode_awal'] ?? null,
                'xp' => $baris['xp'],
                'urutan' => 1,
            ]);

            foreach ($baris['item'] ?? [] as $i => $item) {
                $tantangan->item()->create([
                    'konten' => $item[0],
                    'benar' => $item[1] ?? null,
                    'urutan_benar' => $item[2] ?? null,
                    'urutan_tampil' => $i + 1,
                ]);
            }

            foreach ($baris['aturan'] ?? [] as $i => $aturan) {
                $tantangan->aturan()->create($aturan + ['urutan' => $i + 1]);
            }
        }
    }

    protected function isi(): array
    {
        return [
            [
                'modul' => 'Dasar Visual',
                'judul' => 'Mengenal kanvas',
                'materi_judul' => 'Kanvas dan bentuk dasar',
                'materi' => '<p>Setiap sketsa p5.js memiliki fungsi <code>setup()</code> yang dijalankan satu kali di awal. Di dalamnya kita menyiapkan area gambar, lalu menggambar.</p>'
                    . '<pre>function setup() {' . "\n" . '  createCanvas(320, 320);' . "\n" . '  background(13, 17, 32);' . "\n" . '  fill(255, 179, 57);' . "\n" . '  circle(160, 160, 120);' . "\n" . '}</pre>'
                    . '<p><code>createCanvas(lebar, tinggi)</code> wajib dipanggil lebih dahulu, karena tanpa kanvas tidak ada tempat untuk menggambar.</p>',
                'jenis' => 'pilihan_ganda',
                'xp' => 20,
                'instruksi' => 'Fungsi mana yang harus dipanggil lebih dahulu agar tersedia area untuk menggambar?',
                'item' => [
                    ['createCanvas()', true, null],
                    ['background()', false, null],
                    ['circle()', false, null],
                    ['fill()', false, null],
                ],
            ],
            [
                'modul' => 'Algoritma',
                'judul' => 'Menyusun langkah',
                'materi_judul' => 'Urutan perintah menentukan hasil',
                'materi' => '<p>Komputer menjalankan perintah dari atas ke bawah. Perintah yang dijalankan belakangan akan menimpa hasil perintah sebelumnya.</p>'
                    . '<p>Karena itu <code>background()</code> harus dipanggil <b>sebelum</b> bentuk digambar. Bila dipanggil setelahnya, latar akan menutupi bentuk yang sudah ada.</p>'
                    . '<p>Menyusun urutan langkah sebelum menuliskannya menjadi kode adalah inti dari berpikir algoritmik.</p>',
                'jenis' => 'drag_drop',
                'xp' => 30,
                'instruksi' => 'Susun keempat langkah berikut agar menghasilkan lingkaran kuning di atas latar gelap.',
                'item' => [
                    ['circle(160, 160, 120)', null, 4],
                    ['createCanvas(320, 320)', null, 1],
                    ['fill(255, 179, 57)', null, 3],
                    ['background(13, 17, 32)', null, 2],
                ],
            ],
            [
                'modul' => 'Perulangan',
                'judul' => 'Jembatan tiga pilar',
                'materi_judul' => 'Mengulang tanpa menyalin perintah',
                'materi' => '<p>Ketika beberapa objek digambar dengan pola teratur, menuliskan perintah yang sama berkali-kali membuat kode panjang dan sulit diubah.</p>'
                    . '<pre>for (let i = 0; i &lt; 3; i++) {' . "\n" . '  rect(60 + i * 90, 100, 44, 120);' . "\n" . '}</pre>'
                    . '<p>Variabel <code>i</code> bernilai 0, lalu 1, lalu 2. Nilai itu dipakai untuk menggeser posisi setiap persegi.</p>',
                'jenis' => 'koding',
                'xp' => 40,
                'instruksi' => 'Jembatan ini butuh tiga pilar, tetapi perulangannya baru berjalan dua kali. Ubah agar menghasilkan tiga pilar.',
                'kode_awal' => "function setup() {\n  createCanvas(320, 320);\n  background(13, 17, 32);\n  noStroke();\n  fill(255, 179, 57);\n\n  for (let i = 0; i < 2; i++) {\n    rect(60 + i * 90, 100, 44, 120);\n  }\n\n  fill(79, 209, 197);\n  rect(40, 228, 240, 12);\n}",
                'aturan' => [
                    ['jenis_aturan' => 'kanvas_terbentuk', 'pesan_gagal' => 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().'],
                    ['jenis_aturan' => 'mengandung_teks', 'target' => 'for', 'pesan_gagal' => 'Misi ini harus diselesaikan dengan perulangan. Gunakan for, jangan menulis rect() berkali-kali.'],
                    ['jenis_aturan' => 'jumlah_panggil', 'target' => 'rect', 'cakupan' => 'setup', 'operator' => '=', 'nilai' => 4, 'pesan_gagal' => 'Jumlah persegi belum tepat. Jembatan membutuhkan 3 pilar dan 1 alas.'],
                ],
            ],
            [
                'modul' => 'Animasi',
                'judul' => 'Membuatnya bergerak',
                'materi_judul' => 'Fungsi draw() dan animasi',
                'materi' => '<p>Selain <code>setup()</code>, p5.js mengenal fungsi <code>draw()</code> yang dijalankan berulang kali, sekitar 60 kali setiap detik.</p>'
                    . '<pre>let x = 40;' . "\n\n" . 'function draw() {' . "\n" . '  circle(x, 160, 44);' . "\n" . '  x = x + 4;' . "\n" . '}</pre>'
                    . '<p>Animasi lahir dari perubahan kecil pada setiap putaran. Bila nilainya tidak pernah berubah, gambar terlihat diam.</p>',
                'jenis' => 'koding',
                'xp' => 50,
                'instruksi' => 'Lingkaran digambar berulang kali tetapi tidak berpindah, karena setiap putaran hanya ditambah 0. Ganti angka tersebut.',
                'kode_awal' => "let x = 40;\n\nfunction setup() {\n  createCanvas(320, 320);\n  noStroke();\n}\n\nfunction draw() {\n  background(13, 17, 32, 30);\n  fill(79, 209, 197);\n  circle(x, 160, 44);\n\n  // Ganti 0 dengan angka lain agar lingkaran berpindah\n  x = x + 0;\n\n  if (x > width) {\n    x = 0;\n  }\n}",
                'aturan' => [
                    ['jenis_aturan' => 'kanvas_terbentuk', 'pesan_gagal' => 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().'],
                    ['jenis_aturan' => 'mengandung_teks', 'target' => 'function draw', 'pesan_gagal' => 'Fungsi draw() belum ada. Animasi membutuhkan draw() agar berjalan terus-menerus.'],
                    ['jenis_aturan' => 'jumlah_panggil', 'target' => 'circle', 'cakupan' => 'draw', 'operator' => '>=', 'nilai' => 5, 'pesan_gagal' => 'draw() belum menggambar apa pun. Pastikan circle() dipanggil di dalam draw().'],
                    ['jenis_aturan' => 'tidak_mengandung', 'target' => 'x = x + 0', 'pesan_gagal' => 'Nilai x masih ditambah 0, sehingga lingkaran tidak berpindah. Ganti dengan angka lebih besar dari 0, misalnya 4.'],
                ],
            ],
        ];
    }
}
