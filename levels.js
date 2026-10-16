// Data semua misi. Menambah misi baru cukup menambah satu objek di array ini.
//
// Tiap misi punya:
//   id      : penanda unik, dipakai untuk menyimpan progres
//   judul   : nama misi
//   bab     : nama modul/bab
//   xp      : poin yang didapat saat misi selesai
//   brief   : instruksi untuk pengguna (boleh pakai tag HTML sederhana)
//   petunjuk: teks pendek di samping tombol
//   kode    : kode awal yang muncul di editor
//   periksa : fungsi penilaian. Menerima data hasil menjalankan kode,
//             mengembalikan { lulus: true } atau { lulus: false, pesan: "..." }
//
// Data yang diterima fungsi periksa:
//   kode          : teks kode yang ditulis pengguna
//   setelahSetup  : jumlah pemanggilan tiap fungsi p5 sampai setup() selesai
//   total         : jumlah pemanggilan tiap fungsi p5 sampai pemeriksaan
//   adaKanvas     : true jika createCanvas() berhasil membuat kanvas

const DAFTAR_MISI = [
  {
    id: 'bentuk-pertama',
    judul: 'Bentuk pertama',
    bab: 'Dasar',
    xp: 20,
    brief: `
      <p>Setiap sketsa p5.js punya fungsi <code>setup()</code> yang dijalankan sekali di awal.
      Di dalamnya kita siapkan kanvas, lalu menggambar.</p>
      <p><b>Misi:</b> besarkan lingkaran menjadi <code>200</code>, lalu tambahkan sebuah
      persegi dengan <code>square(60, 60, 80)</code>.</p>
    `,
    petunjuk: 'circle(x, y, diameter)',
    kode: `function setup() {
  createCanvas(320, 320);
  background(13, 17, 32);
  noStroke();
  fill(255, 179, 57);
  circle(160, 160, 120);
}`,
    periksa(data) {
      if (!data.adaKanvas) {
        return { lulus: false, pesan: 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().' };
      }
      if (!data.setelahSetup.circle) {
        return { lulus: false, pesan: 'Belum ada lingkaran. Pastikan circle() masih dipanggil.' };
      }
      if (!data.setelahSetup.square) {
        return { lulus: false, pesan: 'Perseginya belum ada. Tambahkan square(60, 60, 80) di dalam setup().' };
      }
      if (!/circle\s*\(\s*160\s*,\s*160\s*,\s*200\s*\)/.test(data.kode)) {
        return { lulus: false, pesan: 'Perseginya sudah ada. Sekarang ubah ukuran lingkaran dari 120 menjadi 200.' };
      }
      return { lulus: true };
    }
  },

  {
    id: 'tiga-pilar',
    judul: 'Jembatan tiga pilar',
    bab: 'Perulangan',
    xp: 40,
    brief: `
      <p>Jembatan ini butuh tiga pilar. Tukang batunya hanya mau menerima
      <b>satu perintah yang diulang</b>, bukan tiga perintah terpisah.</p>
      <p><b>Misi:</b> gunakan <code>for</code> untuk menggambar tiga persegi panjang
      berjarak sama. Saat ini perulangannya baru berjalan dua kali.</p>
    `,
    petunjuk: 'for (let i = 0; i < n; i++)',
    kode: `function setup() {
  createCanvas(320, 320);
  background(13, 17, 32);
  noStroke();
  fill(255, 179, 57);

  for (let i = 0; i < 2; i++) {
    rect(60 + i * 90, 100, 44, 120);
  }

  fill(79, 209, 197);
  rect(40, 228, 240, 12);
}`,
    periksa(data) {
      if (!data.adaKanvas) {
        return { lulus: false, pesan: 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().' };
      }
      if (!/\bfor\s*\(/.test(data.kode)) {
        return { lulus: false, pesan: 'Misi ini harus diselesaikan dengan perulangan. Gunakan for, jangan menulis rect() berkali-kali.' };
      }
      const jumlahPilar = (data.setelahSetup.rect || 0) - 1; // satu rect dipakai untuk alas jembatan
      if (jumlahPilar < 3) {
        return { lulus: false, pesan: `Hampir. Perulanganmu baru menggambar ${jumlahPilar} pilar, sedangkan jembatan butuh 3.` };
      }
      if (jumlahPilar > 3) {
        return { lulus: false, pesan: `Pilarnya jadi ${jumlahPilar} buah, kelebihan. Jembatan ini hanya butuh 3.` };
      }
      return { lulus: true };
    }
  },

  {
    id: 'membuat-bergerak',
    judul: 'Membuatnya bergerak',
    bab: 'Animasi',
    xp: 60,
    brief: `
      <p>Fungsi <code>draw()</code> berjalan terus-menerus, sekitar 60 kali per detik.
      Di sinilah animasi lahir: ubah sedikit nilainya setiap putaran.</p>
      <p><b>Misi:</b> lengkapi baris yang kosong agar lingkaran bergerak ke kanan,
      lalu kembali ke kiri saat melewati tepi kanvas.</p>
    `,
    petunjuk: 'draw() berulang terus',
    kode: `let x = 0;

function setup() {
  createCanvas(320, 320);
  noStroke();
}

function draw() {
  background(13, 17, 32, 30);
  fill(79, 209, 197);
  circle(x, 160, 44);

  // Tambahkan nilai x di sini agar lingkaran bergerak


  if (x > width) {
    x = 0;
  }
}`,
    periksa(data) {
      if (!data.adaKanvas) {
        return { lulus: false, pesan: 'Kanvas belum terbentuk. Pastikan ada createCanvas() di dalam setup().' };
      }
      if (!/function\s+draw\s*\(/.test(data.kode)) {
        return { lulus: false, pesan: 'Fungsi draw() belum ada. Animasi butuh draw() agar berjalan terus-menerus.' };
      }
      const gambarDiDraw = (data.total.circle || 0) - (data.setelahSetup.circle || 0);
      if (gambarDiDraw < 5) {
        return { lulus: false, pesan: 'draw() belum menggambar apa pun. Pastikan circle() dipanggil di dalam draw().' };
      }
      if (!/x\s*=\s*x\s*\+|x\s*\+=|x\+\+/.test(data.kode)) {
        return { lulus: false, pesan: 'Lingkarannya menggambar, tapi belum bergerak. Nilai x harus bertambah setiap putaran draw().' };
      }
      return { lulus: true };
    }
  }
];
