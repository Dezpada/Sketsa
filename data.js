// ============================================================
// Berkas ini berperan sebagai pengganti basis data.
// Strukturnya sengaja dibuat sama persis dengan tabel yang
// akan dibuat di Laravel, sehingga rancangan basis data dapat
// diuji lebih dahulu sebelum dibangun.
//
// Tabel: modul, level, materi, tantangan,
//        tantangan_item, tantangan_aturan
// ============================================================

const DATA = {

  modul: [
    { id: 1, nama: 'Dasar Visual', urutan: 1 },
    { id: 2, nama: 'Algoritma', urutan: 2 },
    { id: 3, nama: 'Perulangan', urutan: 3 },
    { id: 4, nama: 'Animasi', urutan: 4 },
  ],

  level: [
    { id: 1, modul_id: 1, judul: 'Mengenal kanvas', urutan: 1 },
    { id: 2, modul_id: 2, judul: 'Menyusun langkah', urutan: 2 },
    { id: 3, modul_id: 3, judul: 'Jembatan tiga pilar', urutan: 3 },
    { id: 4, modul_id: 4, judul: 'Membuatnya bergerak', urutan: 4 },
  ],

  materi: [
    {
      id: 1, level_id: 1, urutan: 1,
      judul: 'Kanvas dan bentuk dasar',
      konten: `
        <p>Setiap sketsa p5.js memiliki fungsi <code>setup()</code> yang dijalankan
        satu kali di awal. Di dalamnya kita menyiapkan area gambar, lalu menggambar.</p>
        <pre>function setup() {
  createCanvas(320, 320);   // menyiapkan area gambar
  background(13, 17, 32);   // mewarnai latar
  fill(255, 179, 57);       // menentukan warna isi
  circle(160, 160, 120);    // menggambar lingkaran
}</pre>
        <p><code>createCanvas(lebar, tinggi)</code> wajib dipanggil lebih dahulu,
        karena tanpa kanvas tidak ada tempat untuk menggambar.</p>
        <p><code>circle(x, y, diameter)</code> menggambar lingkaran dengan titik
        tengah pada koordinat <code>x</code> dan <code>y</code>.</p>
      `
    },
    {
      id: 2, level_id: 2, urutan: 1,
      judul: 'Urutan perintah menentukan hasil',
      konten: `
        <p>Komputer menjalankan perintah dari atas ke bawah. Perintah yang
        dijalankan belakangan akan menimpa hasil perintah sebelumnya.</p>
        <p>Karena itu <code>background()</code> harus dipanggil <b>sebelum</b>
        bentuk digambar. Bila dipanggil setelahnya, latar akan menutupi bentuk
        yang sudah ada sehingga kanvas terlihat kosong.</p>
        <p>Menyusun urutan langkah sebelum menuliskannya menjadi kode adalah inti
        dari berpikir algoritmik.</p>
      `
    },
    {
      id: 3, level_id: 3, urutan: 1,
      judul: 'Mengulang tanpa menyalin perintah',
      konten: `
        <p>Ketika beberapa objek digambar dengan pola teratur, menuliskan
        perintah yang sama berkali-kali membuat kode panjang dan sulit diubah.</p>
        <pre>for (let i = 0; i &lt; 3; i++) {
  rect(60 + i * 90, 100, 44, 120);
}</pre>
        <p>Variabel <code>i</code> bernilai 0, lalu 1, lalu 2. Nilai itu dipakai
        untuk menggeser posisi setiap persegi, sehingga satu perintah
        menghasilkan tiga bentuk sekaligus.</p>
      `
    },
    {
      id: 4, level_id: 4, urutan: 1,
      judul: 'Fungsi draw() dan animasi',
      konten: `
        <p>Selain <code>setup()</code>, p5.js mengenal fungsi <code>draw()</code>
        yang dijalankan berulang kali, sekitar 60 kali setiap detik.</p>
        <pre>let x = 40;

function draw() {
  circle(x, 160, 44);
  x = x + 4;        // posisi berubah setiap putaran
}</pre>
        <p>Animasi lahir dari perubahan kecil yang terjadi pada setiap putaran.
        Bila nilainya tidak pernah berubah, gambar akan terlihat diam meskipun
        <code>draw()</code> tetap berjalan.</p>
      `
    },
  ],

  tantangan: [
    {
      id: 1, level_id: 1, urutan: 1, jenis: 'pilihan_ganda', xp: 20,
      instruksi: 'Fungsi mana yang harus dipanggil lebih dahulu agar tersedia area untuk menggambar?',
      kode_awal: null
    },
    {
      id: 2, level_id: 2, urutan: 1, jenis: 'drag_drop', xp: 30,
      instruksi: 'Susun keempat langkah berikut agar menghasilkan lingkaran kuning di atas latar gelap.',
      kode_awal: null
    },
    {
      id: 3, level_id: 3, urutan: 1, jenis: 'koding', xp: 40,
      instruksi: 'Jembatan ini butuh tiga pilar, tetapi perulangannya baru berjalan dua kali. Ubah agar menghasilkan tiga pilar.',
      kode_awal: `function setup() {
  createCanvas(320, 320);
  background(13, 17, 32);
  noStroke();
  fill(255, 179, 57);

  for (let i = 0; i < 2; i++) {
    rect(60 + i * 90, 100, 44, 120);
  }

  fill(79, 209, 197);
  rect(40, 228, 240, 12);
}`
    },
    {
      id: 4, level_id: 4, urutan: 1, jenis: 'koding', xp: 50,
      instruksi: 'Lingkaran digambar berulang kali tetapi tidak berpindah, karena setiap putaran hanya ditambah 0. Ganti angka tersebut.',
      kode_awal: `let x = 40;

function setup() {
  createCanvas(320, 320);
  noStroke();
}

function draw() {
  background(13, 17, 32, 30);
  fill(79, 209, 197);
  circle(x, 160, 44);

  // Ganti 0 dengan angka lain agar lingkaran berpindah
  x = x + 0;

  if (x > width) {
    x = 0;
  }
}`
    },
  ],

  // Dipakai oleh tantangan pilihan ganda dan drag and drop.
  // Kolom "benar" untuk pilihan ganda, "urutan_benar" untuk drag and drop.
  tantangan_item: [
    { id: 1, tantangan_id: 1, konten: 'createCanvas()', benar: true,  urutan_benar: null, urutan_tampil: 1 },
    { id: 2, tantangan_id: 1, konten: 'background()',  benar: false, urutan_benar: null, urutan_tampil: 2 },
    { id: 3, tantangan_id: 1, konten: 'circle()',      benar: false, urutan_benar: null, urutan_tampil: 3 },
    { id: 4, tantangan_id: 1, konten: 'fill()',        benar: false, urutan_benar: null, urutan_tampil: 4 },

    { id: 5, tantangan_id: 2, konten: 'circle(160, 160, 120)',  benar: null, urutan_benar: 4, urutan_tampil: 1 },
    { id: 6, tantangan_id: 2, konten: 'createCanvas(320, 320)', benar: null, urutan_benar: 1, urutan_tampil: 2 },
    { id: 7, tantangan_id: 2, konten: 'fill(255, 179, 57)',     benar: null, urutan_benar: 3, urutan_tampil: 3 },
    { id: 8, tantangan_id: 2, konten: 'background(13, 17, 32)', benar: null, urutan_benar: 2, urutan_tampil: 4 },
  ],

  // Hanya dipakai tantangan berjenis koding.
  // Inilah pengganti fungsi penilaian yang sebelumnya ditulis tangan:
  // pengelola cukup menyusun baris-baris aturan melalui formulir.
  //
  // jenis_aturan : kanvas_terbentuk | mengandung_teks | tidak_mengandung | jumlah_panggil
  // cakupan      : setup | draw | semua   (khusus jumlah_panggil)
  tantangan_aturan: [
    { id: 1, tantangan_id: 3, urutan: 1, jenis_aturan: 'kanvas_terbentuk',
      target: null, cakupan: null, operator: null, nilai: null,
      pesan_gagal: 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().' },

    { id: 2, tantangan_id: 3, urutan: 2, jenis_aturan: 'mengandung_teks',
      target: 'for', cakupan: null, operator: null, nilai: null,
      pesan_gagal: 'Misi ini harus diselesaikan dengan perulangan. Gunakan for, jangan menulis rect() berkali-kali.' },

    { id: 3, tantangan_id: 3, urutan: 3, jenis_aturan: 'jumlah_panggil',
      target: 'rect', cakupan: 'setup', operator: '=', nilai: 4,
      pesan_gagal: 'Jumlah persegi belum tepat. Jembatan membutuhkan 3 pilar dan 1 alas.' },

    { id: 4, tantangan_id: 4, urutan: 1, jenis_aturan: 'kanvas_terbentuk',
      target: null, cakupan: null, operator: null, nilai: null,
      pesan_gagal: 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().' },

    { id: 5, tantangan_id: 4, urutan: 2, jenis_aturan: 'mengandung_teks',
      target: 'function draw', cakupan: null, operator: null, nilai: null,
      pesan_gagal: 'Fungsi draw() belum ada. Animasi membutuhkan draw() agar berjalan terus-menerus.' },

    { id: 6, tantangan_id: 4, urutan: 3, jenis_aturan: 'jumlah_panggil',
      target: 'circle', cakupan: 'draw', operator: '>=', nilai: 5,
      pesan_gagal: 'draw() belum menggambar apa pun. Pastikan circle() dipanggil di dalam draw().' },

    { id: 7, tantangan_id: 4, urutan: 4, jenis_aturan: 'tidak_mengandung',
      target: 'x = x + 0', cakupan: null, operator: null, nilai: null,
      pesan_gagal: 'Nilai x masih ditambah 0, sehingga lingkaran tidak berpindah. Ganti dengan angka lebih besar dari 0, misalnya 4.' },
  ],
};
