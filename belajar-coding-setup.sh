#!/usr/bin/env bash
# Membuat seluruh file purwarupa Sketsa di folder saat ini.
set -e

cat > index.html <<'SKETSA_EOF'
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Sketsa — belajar koding lewat visual</title>
<link rel="stylesheet" href="style.css">
</head>
<body>

<header class="bar">
  <div class="brand">
    <b>Sketsa</b>
    <span>belajar koding lewat visual</span>
  </div>

  <div class="avatar" aria-hidden="true">
    <svg viewBox="0 0 38 38"><circle cx="19" cy="19" r="19"/><circle cx="19" cy="15" r="6"/><path d="M8 32 Q19 19 30 32 Z"/></svg>
  </div>

  <div class="stat">
    <span class="lvl" id="level">1</span>
    <div class="xpwrap">
      <div class="xptrack"><div class="xpfill" id="xp-fill"></div></div>
      <div class="xpnum" id="xp-num">0 XP</div>
    </div>
  </div>
</header>

<main class="wrap">

  <nav class="peta" aria-label="Peta misi">
    <h2>Peta misi</h2>
    <div id="daftar-level"></div>
  </nav>

  <div class="kerja">

    <!-- ---------- Tahap 1: materi ---------- -->
    <section class="panel" id="panel-materi">
      <div class="phead">
        <h3 id="judul-materi">Memuat…</h3>
        <span class="tag" id="tag-materi"></span>
      </div>
      <div class="brief" id="isi-materi"></div>
      <div class="aksi">
        <button class="btn utama" id="tombol-mulai">Mulai tantangan</button>
        <span class="petunjuk">Pelajari materi sebelum mengerjakan tantangan</span>
      </div>
    </section>

    <!-- ---------- Tahap 2: tantangan ---------- -->
    <div class="area-tantangan" id="area-tantangan" hidden>

      <div class="kolom">
        <section class="panel">
          <div class="phead">
            <h3 id="judul-tantangan">Tantangan</h3>
            <span class="tag" id="tag-tantangan"></span>
          </div>
          <div class="brief" id="instruksi-tantangan"></div>
          <div id="isi-soal"></div>
          <div class="aksi">
            <button class="btn utama" id="tombol-kirim">Periksa jawaban</button>
            <button class="btn samar" id="tombol-reset" hidden>Kembalikan kode awal</button>
            <button class="btn samar" id="tombol-kembali">Baca materi lagi</button>
          </div>
          <div class="log" id="log-soal" hidden></div>
        </section>
      </div>

      <section class="panel" id="panel-hasil" hidden>
        <div class="phead">
          <h3>Hasil</h3>
          <span class="tag">iframe sandbox</span>
        </div>
        <div class="panggung">
          <iframe id="panggung" title="Hasil kode" sandbox="allow-scripts"></iframe>
        </div>
        <div class="log" id="log-kode">Tekan Jalankan untuk melihat hasilnya.</div>
      </section>

    </div>
  </div>
</main>

<div class="pop" id="pop" role="status" aria-live="polite"></div>

<script src="data.js"></script>
<script src="app.js"></script>
</body>
</html>
SKETSA_EOF

cat > style.css <<'SKETSA_EOF'
:root {
  --bg: #eef0f6;
  --surface: #ffffff;
  --surface-2: #f6f7fb;
  --line: #d8dce8;
  --ink: #1b2033;
  --ink-2: #5c6484;
  --amber: #ef9f27;
  --teal: #0f8f84;
  --merah: #c0392b;
  --panggung: #0d1120;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #11162a;
    --surface: #1b2138;
    --surface-2: #222942;
    --line: #2e3657;
    --ink: #e8eaf2;
    --ink-2: #8b93ad;
    --teal: #4fd1c5;
    --merah: #ff8a80;
  }
}

* { box-sizing: border-box; }

body {
  margin: 0;
  background: var(--bg);
  color: var(--ink);
  font-family: system-ui, -apple-system, "Segoe UI", sans-serif;
  font-size: 15px;
  line-height: 1.55;
}

/* ---------- bar atas ---------- */
.bar {
  position: sticky; top: 0; z-index: 20;
  display: flex; align-items: center; gap: 14px;
  padding: 10px 16px;
  background: var(--surface);
  border-bottom: 1px solid var(--line);
  flex-wrap: wrap;
}
.brand { display: flex; align-items: baseline; gap: 8px; margin-right: auto; }
.brand b { font-size: 17px; letter-spacing: -0.02em; }
.brand span { font-size: 12.5px; color: var(--ink-2); }

.avatar svg { width: 32px; height: 32px; display: block; }
.avatar svg circle:first-child { fill: #faeeda; }
.avatar svg circle:last-of-type, .avatar svg path { fill: #854f0b; }

.stat { display: flex; align-items: center; gap: 10px; }
.lvl {
  display: inline-grid; place-items: center;
  min-width: 26px; height: 26px; padding: 0 7px;
  border-radius: 7px; background: var(--amber); color: #412402;
  font-weight: 700; font-size: 13px;
}
.xpwrap { width: 150px; }
.xptrack { height: 4px; border-radius: 2px; background: var(--line); overflow: hidden; }
.xpfill { height: 100%; width: 0; background: var(--amber); transition: width 0.45s ease; }
.xpnum { margin-top: 4px; font-size: 11.5px; color: var(--ink-2); font-family: ui-monospace, monospace; }

/* ---------- tata letak ---------- */
.wrap { max-width: 1180px; margin: 0 auto; padding: 16px; display: grid; gap: 16px; }

@media (min-width: 980px) {
  .wrap { grid-template-columns: 230px 1fr; align-items: start; }
  .peta { position: sticky; top: 86px; }
  .area-tantangan.dua-kolom { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; align-items: start; }
}

.kolom { display: grid; gap: 16px; align-content: start; }
.area-tantangan { display: grid; gap: 16px; align-items: start; }

/* ---------- peta misi ---------- */
.peta { background: var(--surface); border: 1px solid var(--line); border-radius: 12px; padding: 8px; }
.peta h2 { margin: 6px 8px 8px; font-size: 12.5px; font-weight: 500; color: var(--ink-2); }

.misi {
  display: flex; gap: 10px; align-items: flex-start; width: 100%;
  padding: 9px; border: 0; border-radius: 9px; background: none;
  color: var(--ink); font: inherit; font-size: 14px; text-align: left; cursor: pointer;
}
.misi:hover { background: var(--surface-2); }
.misi[aria-current="true"] { background: var(--surface-2); box-shadow: inset 2px 0 0 var(--amber); }
.misi:focus-visible { outline: 2px solid var(--amber); outline-offset: 1px; }
.misi i {
  min-width: 16px; padding-top: 1px; font-style: normal;
  font-family: ui-monospace, monospace; font-size: 12px; color: var(--ink-2);
}
.misi.selesai i { color: var(--teal); }
.misi em { display: block; font-style: normal; font-size: 11.5px; color: var(--ink-2); }

/* ---------- panel ---------- */
.panel { background: var(--surface); border: 1px solid var(--line); border-radius: 12px; overflow: hidden; }
.phead {
  display: flex; align-items: center; gap: 10px;
  padding: 11px 14px; border-bottom: 1px solid var(--line);
}
.phead h3 { margin: 0; font-size: 14px; font-weight: 500; }
.phead .tag { margin-left: auto; font-family: ui-monospace, monospace; font-size: 11px; color: var(--ink-2); }

.brief { padding: 13px 14px; font-size: 14px; }
.brief p { margin: 0 0 9px; }
.brief p:last-child { margin-bottom: 0; }
.brief code {
  padding: 1.5px 5px; border-radius: 5px; background: var(--surface-2);
  font-family: ui-monospace, monospace; font-size: 12.5px;
}
.brief pre {
  margin: 0 0 10px; padding: 11px 13px; border-radius: 8px; overflow-x: auto;
  background: var(--panggung); color: #d7dcf0;
  font-family: ui-monospace, monospace; font-size: 12.5px; line-height: 1.6;
}

/* ---------- pilihan ganda ---------- */
.opsi-list { display: grid; gap: 8px; padding: 0 14px 4px; }
.opsi {
  display: flex; align-items: center; gap: 10px; width: 100%;
  padding: 11px 13px; border: 1px solid var(--line); border-radius: 9px;
  background: var(--surface); color: var(--ink);
  font: inherit; font-size: 14px; text-align: left; cursor: pointer;
}
.opsi:hover { border-color: var(--ink-2); }
.opsi:focus-visible { outline: 2px solid var(--amber); outline-offset: 1px; }
.opsi[aria-pressed="true"] { border-color: var(--amber); box-shadow: inset 0 0 0 1px var(--amber); }
.opsi b {
  display: inline-grid; place-items: center; min-width: 24px; height: 24px;
  border-radius: 6px; background: var(--surface-2);
  font-family: ui-monospace, monospace; font-size: 12px; font-weight: 500;
}
.opsi[aria-pressed="true"] b { background: var(--amber); color: #412402; }

/* ---------- drag and drop ---------- */
.urut-list { display: grid; gap: 8px; padding: 0 14px 4px; list-style: none; margin: 0; }
.urut {
  display: flex; align-items: center; gap: 10px;
  padding: 11px 13px; border: 1px solid var(--line); border-radius: 9px;
  background: var(--surface); cursor: grab; touch-action: none;
  font-family: ui-monospace, monospace; font-size: 12.5px;
}
.urut:focus-visible { outline: 2px solid var(--amber); outline-offset: 1px; }
.urut .pegangan { color: var(--ink-2); font-family: system-ui, sans-serif; font-size: 15px; }
.urut .nomor {
  display: inline-grid; place-items: center; min-width: 24px; height: 24px;
  border-radius: 6px; background: var(--surface-2); color: var(--ink-2);
  font-size: 12px; flex-shrink: 0;
}
.urut.menyeret { opacity: 0.55; border-color: var(--amber); cursor: grabbing; }

/* ---------- editor kode ---------- */
.editor {
  display: block; width: 100%; min-height: 250px; padding: 13px 14px;
  border: 0; border-top: 1px solid var(--line); resize: vertical;
  background: var(--panggung); color: #d7dcf0;
  font-family: ui-monospace, "SF Mono", Menlo, monospace;
  font-size: 13px; line-height: 1.65; tab-size: 2;
}
.editor:focus { outline: 2px solid var(--amber); outline-offset: -2px; }

/* ---------- aksi ---------- */
.aksi {
  display: flex; align-items: center; gap: 9px;
  padding: 11px 14px; border-top: 1px solid var(--line); flex-wrap: wrap;
}
.btn {
  padding: 8px 15px; border: 1px solid transparent; border-radius: 8px;
  font: inherit; font-size: 14px; font-weight: 500; cursor: pointer;
}
.btn:focus-visible { outline: 2px solid var(--amber); outline-offset: 2px; }
.utama { background: var(--amber); color: #412402; }
.utama:hover { filter: brightness(1.07); }
.samar { background: transparent; color: var(--ink-2); border-color: var(--line); }
.samar:hover { color: var(--ink); border-color: var(--ink-2); }
.petunjuk { margin-left: auto; font-size: 12.5px; color: var(--ink-2); }

/* ---------- panggung hasil ---------- */
.panggung { display: grid; place-items: center; padding: 16px; min-height: 300px; background: var(--panggung); }
.panggung iframe {
  width: 320px; height: 320px; max-width: 100%;
  border: 0; border-radius: 8px; background: #0a0e1a; display: block;
}

/* ---------- baris pesan ---------- */
.log {
  min-height: 34px; padding: 10px 14px; border-top: 1px solid var(--line);
  font-size: 13px; line-height: 1.5;
}
#log-kode { background: var(--panggung); color: #8b93ad; font-family: ui-monospace, monospace; font-size: 12px; }
#log-soal { background: var(--surface-2); color: var(--ink-2); }
.log.gagal { color: var(--merah); }
.log.lulus { color: var(--teal); }

/* ---------- notifikasi ---------- */
.pop {
  position: fixed; left: 50%; bottom: 22px; z-index: 50;
  padding: 11px 20px; border-radius: 999px;
  background: var(--amber); color: #412402;
  font-weight: 700; font-size: 14px;
  transform: translate(-50%, 160%);
  transition: transform 0.45s cubic-bezier(0.2, 1.3, 0.4, 1);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.28);
}
.pop.tampil { transform: translate(-50%, 0); }

@media (prefers-reduced-motion: reduce) {
  .pop, .xpfill { transition: none; }
}
SKETSA_EOF

cat > data.js <<'SKETSA_EOF'
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
SKETSA_EOF

cat > app.js <<'SKETSA_EOF'
// ============================================================
// Mesin aplikasi.
//
// Seluruh isi pembelajaran diambil dari DATA (lihat data.js),
// termasuk kriteria penilaian tantangan koding. Tidak ada
// aturan penilaian yang ditulis langsung di berkas ini.
// ============================================================

const ALAMAT_P5 = 'https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js';
const KUNCI_SIMPAN = 'sketsa.progres.v2';
const XP_PER_LEVEL = 100;

const FUNGSI_DIHITUNG = [
  'circle', 'ellipse', 'rect', 'square', 'line', 'triangle',
  'point', 'arc', 'text', 'fill', 'background', 'createCanvas'
];

const $ = (id) => document.getElementById(id);

/* ============ pembacaan data (pengganti query basis data) ============ */

const db = {
  levelUrut: () => [...DATA.level].sort((a, b) => a.urutan - b.urutan),
  modul: (id) => DATA.modul.find((m) => m.id === id),
  materiLevel: (levelId) => DATA.materi.filter((m) => m.level_id === levelId).sort((a, b) => a.urutan - b.urutan),
  tantanganLevel: (levelId) => DATA.tantangan.find((t) => t.level_id === levelId),
  itemTantangan: (tId) => DATA.tantangan_item.filter((i) => i.tantangan_id === tId).sort((a, b) => a.urutan_tampil - b.urutan_tampil),
  aturanTantangan: (tId) => DATA.tantangan_aturan.filter((a) => a.tantangan_id === tId).sort((a, b) => a.urutan - b.urutan),
};

/* ============ keadaan aplikasi ============ */

let progres = { xp: 0, selesai: [], levelAktif: db.levelUrut()[0].id };
let tahap = 'materi';
const kodeDiedit = {};
let menungguHasilKode = false;

function muatProgres() {
  try {
    const t = localStorage.getItem(KUNCI_SIMPAN);
    if (!t) return;
    const d = JSON.parse(t);
    progres = {
      xp: d.xp || 0,
      selesai: Array.isArray(d.selesai) ? d.selesai : [],
      levelAktif: d.levelAktif || db.levelUrut()[0].id,
    };
  } catch (e) { /* penyimpanan tidak tersedia */ }
}

function simpanProgres() {
  try { localStorage.setItem(KUNCI_SIMPAN, JSON.stringify(progres)); } catch (e) {}
}

function levelTerbuka(level) {
  const urut = db.levelUrut();
  const i = urut.findIndex((l) => l.id === level.id);
  if (i <= 0) return true;
  return progres.selesai.includes(urut[i - 1].id);
}

/* ============ tampilan umum ============ */

function levelSekarang() { return Math.floor(progres.xp / XP_PER_LEVEL) + 1; }

function gambarStatistik() {
  const sisa = progres.xp % XP_PER_LEVEL;
  $('level').textContent = levelSekarang();
  $('xp-fill').style.width = sisa + '%';
  $('xp-num').textContent = progres.xp + ' XP · ' + (XP_PER_LEVEL - sisa) + ' lagi';
}

function gambarPeta() {
  const wadah = $('daftar-level');
  wadah.innerHTML = '';

  db.levelUrut().forEach((level, nomor) => {
    const selesai = progres.selesai.includes(level.id);
    const terbuka = levelTerbuka(level);
    const tantangan = db.tantanganLevel(level.id);

    const tombol = document.createElement('button');
    tombol.className = 'misi' + (selesai ? ' selesai' : '');
    tombol.disabled = !terbuka;
    if (level.id === progres.levelAktif) tombol.setAttribute('aria-current', 'true');

    const tanda = document.createElement('i');
    tanda.textContent = selesai ? '✓' : (terbuka ? String(nomor + 1) : '🔒');

    const teks = document.createElement('span');
    teks.textContent = level.judul;
    const ket = document.createElement('em');
    const modul = db.modul(level.modul_id);
    ket.textContent = (modul ? modul.nama : '') + ' · ' + namaJenis(tantangan.jenis) + ' · ' + tantangan.xp + ' XP';
    teks.appendChild(ket);

    tombol.append(tanda, teks);
    tombol.onclick = () => {
      progres.levelAktif = level.id;
      tahap = 'materi';
      simpanProgres();
      gambarSemua();
    };
    wadah.appendChild(tombol);
  });
}

function namaJenis(jenis) {
  if (jenis === 'pilihan_ganda') return 'Pilihan ganda';
  if (jenis === 'drag_drop') return 'Susun urutan';
  return 'Menulis kode';
}

/* ============ tahap materi ============ */

function gambarMateri() {
  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  const daftar = db.materiLevel(level.id);
  const materi = daftar[0];

  $('judul-materi').textContent = materi ? materi.judul : level.judul;
  const urut = db.levelUrut();
  $('tag-materi').textContent = 'Level ' + (urut.findIndex((l) => l.id === level.id) + 1) + ' dari ' + urut.length;
  $('isi-materi').innerHTML = materi ? materi.konten : '<p>Materi belum tersedia.</p>';
}

/* ============ tahap tantangan ============ */

function gambarTantangan() {
  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  const tantangan = db.tantanganLevel(level.id);

  $('judul-tantangan').textContent = level.judul;
  $('tag-tantangan').textContent = namaJenis(tantangan.jenis) + ' · ' + tantangan.xp + ' XP';
  $('instruksi-tantangan').innerHTML = '<p>' + tantangan.instruksi + '</p>';

  const isi = $('isi-soal');
  isi.innerHTML = '';
  pesanSoal('', '');

  const koding = tantangan.jenis === 'koding';
  $('panel-hasil').hidden = !koding;
  $('tombol-reset').hidden = !koding;
  $('area-tantangan').classList.toggle('dua-kolom', koding);
  $('tombol-kirim').textContent = koding ? 'Jalankan' : 'Periksa jawaban';

  if (tantangan.jenis === 'pilihan_ganda') gambarPilihanGanda(isi, tantangan);
  else if (tantangan.jenis === 'drag_drop') gambarDragDrop(isi, tantangan);
  else gambarEditorKode(isi, tantangan);
}

function gambarPilihanGanda(wadah, tantangan) {
  const list = document.createElement('div');
  list.className = 'opsi-list';
  const huruf = ['a', 'b', 'c', 'd', 'e', 'f'];

  db.itemTantangan(tantangan.id).forEach((item, i) => {
    const b = document.createElement('button');
    b.className = 'opsi';
    b.type = 'button';
    b.dataset.itemId = item.id;
    b.setAttribute('aria-pressed', 'false');
    const tanda = document.createElement('b');
    tanda.textContent = huruf[i] || String(i + 1);
    const teks = document.createElement('span');
    teks.textContent = item.konten;
    b.append(tanda, teks);
    b.onclick = () => {
      list.querySelectorAll('.opsi').forEach((o) => o.setAttribute('aria-pressed', 'false'));
      b.setAttribute('aria-pressed', 'true');
    };
    list.appendChild(b);
  });

  wadah.appendChild(list);
}

function gambarDragDrop(wadah, tantangan) {
  const ul = document.createElement('ul');
  ul.className = 'urut-list';

  db.itemTantangan(tantangan.id).forEach((item) => {
    const li = document.createElement('li');
    li.className = 'urut';
    li.dataset.itemId = item.id;
    li.tabIndex = 0;
    li.innerHTML = '<span class="nomor"></span><span class="pegangan" aria-hidden="true">⠿</span>';
    const teks = document.createElement('span');
    teks.textContent = item.konten;
    li.appendChild(teks);
    ul.appendChild(li);
  });

  wadah.appendChild(ul);
  perbaruiNomor(ul);
  pasangGeser(ul);
}

function perbaruiNomor(ul) {
  [...ul.children].forEach((li, i) => {
    li.querySelector('.nomor').textContent = String(i + 1);
  });
}

// Penyusunan ulang dengan penunjuk (tetikus maupun sentuh) serta papan ketik.
function pasangGeser(ul) {
  let seret = null;

  ul.addEventListener('pointerdown', (e) => {
    const li = e.target.closest('li');
    if (!li) return;
    seret = li;
    li.classList.add('menyeret');
    li.setPointerCapture(e.pointerId);
  });

  ul.addEventListener('pointermove', (e) => {
    if (!seret) return;
    const atas = document.elementFromPoint(e.clientX, e.clientY);
    const li = atas && atas.closest ? atas.closest('li') : null;
    if (!li || li === seret || li.parentElement !== ul) return;
    const kotak = li.getBoundingClientRect();
    const setelah = e.clientY > kotak.top + kotak.height / 2;
    ul.insertBefore(seret, setelah ? li.nextSibling : li);
    perbaruiNomor(ul);
  });

  const lepas = () => {
    if (!seret) return;
    seret.classList.remove('menyeret');
    seret = null;
  };
  ul.addEventListener('pointerup', lepas);
  ul.addEventListener('pointercancel', lepas);

  ul.addEventListener('keydown', (e) => {
    const li = e.target.closest('li');
    if (!li) return;
    if (e.key === 'ArrowUp' && li.previousElementSibling) {
      e.preventDefault();
      ul.insertBefore(li, li.previousElementSibling);
    } else if (e.key === 'ArrowDown' && li.nextElementSibling) {
      e.preventDefault();
      ul.insertBefore(li.nextElementSibling, li);
    } else {
      return;
    }
    perbaruiNomor(ul);
    li.focus();
  });
}

function gambarEditorKode(wadah, tantangan) {
  const area = document.createElement('textarea');
  area.className = 'editor';
  area.id = 'editor';
  area.spellcheck = false;
  area.setAttribute('aria-label', 'Editor kode');
  area.value = (tantangan.id in kodeDiedit) ? kodeDiedit[tantangan.id] : (tantangan.kode_awal || '');

  area.addEventListener('keydown', (e) => {
    if (e.key !== 'Tab') return;
    e.preventDefault();
    const p = area.selectionStart;
    area.value = area.value.slice(0, p) + '  ' + area.value.slice(area.selectionEnd);
    area.selectionStart = area.selectionEnd = p + 2;
  });

  wadah.appendChild(area);
}

/* ============ penilaian ============ */

function nilaiPilihanGanda(tantangan) {
  const dipilih = $('isi-soal').querySelector('.opsi[aria-pressed="true"]');
  if (!dipilih) return { lulus: false, pesan: 'Pilih salah satu jawaban terlebih dahulu.' };

  const item = db.itemTantangan(tantangan.id).find((i) => String(i.id) === dipilih.dataset.itemId);
  if (item && item.benar) return { lulus: true };
  return { lulus: false, pesan: 'Jawaban belum tepat. Baca lagi materinya, lalu coba sekali lagi.' };
}

function nilaiDragDrop(tantangan) {
  const baris = [...$('isi-soal').querySelectorAll('.urut')];
  const item = db.itemTantangan(tantangan.id);

  for (let i = 0; i < baris.length; i++) {
    const data = item.find((x) => String(x.id) === baris[i].dataset.itemId);
    if (!data || data.urutan_benar !== i + 1) {
      return { lulus: false, pesan: 'Urutannya belum tepat. Perhatikan langkah mana yang harus dijalankan lebih dahulu.' };
    }
  }
  return { lulus: true };
}

// Mesin penilaian tantangan koding.
// Seluruh kriteria dibaca dari tabel tantangan_aturan.
function hitungPanggil(hasil, target, cakupan) {
  const total = hasil.total[target] || 0;
  const setup = hasil.setelahSetup[target] || 0;
  if (cakupan === 'setup') return setup;
  if (cakupan === 'draw') return total - setup;
  return total;
}

function bandingkan(angka, operator, nilai) {
  if (operator === '>=') return angka >= nilai;
  if (operator === '<=') return angka <= nilai;
  return angka === nilai;
}

function cekAturan(aturan, hasil) {
  switch (aturan.jenis_aturan) {
    case 'kanvas_terbentuk': return hasil.adaKanvas;
    case 'mengandung_teks': return hasil.kode.includes(aturan.target);
    case 'tidak_mengandung': return !hasil.kode.includes(aturan.target);
    case 'jumlah_panggil': return bandingkan(hitungPanggil(hasil, aturan.target, aturan.cakupan), aturan.operator, aturan.nilai);
    default: return true;
  }
}

function nilaiKoding(tantangan, hasil) {
  const daftar = db.aturanTantangan(tantangan.id);
  for (const aturan of daftar) {
    if (!cekAturan(aturan, hasil)) return { lulus: false, pesan: aturan.pesan_gagal };
  }
  return { lulus: true };
}

/* ============ menjalankan kode pengguna ============ */

function susunHalamanUji(kodePengguna) {
  const daftar = JSON.stringify(FUNGSI_DIHITUNG);
  const b = [];

  b.push('<!DOCTYPE html><html><head><meta charset="utf-8">');
  b.push('<style>html,body{margin:0;padding:0;overflow:hidden;background:#0a0e1a}canvas{display:block}</style>');
  b.push('<scr' + 'ipt src="' + ALAMAT_P5 + '"></scr' + 'ipt>');
  b.push('</head><body>');

  b.push('<scr' + 'ipt>');
  b.push('var TOTAL = {}, SETELAH_SETUP = {};');
  b.push('(function () {');
  b.push('  ' + daftar + '.forEach(function (nama) {');
  b.push('    var asli = p5.prototype[nama];');
  b.push('    if (!asli) return;');
  b.push('    p5.prototype[nama] = function () {');
  b.push('      TOTAL[nama] = (TOTAL[nama] || 0) + 1;');
  b.push('      return asli.apply(this, arguments);');
  b.push('    };');
  b.push('  });');
  b.push('})();');
  b.push('window.onerror = function (pesan) {');
  b.push('  parent.postMessage({ jenis: "galat", pesan: String(pesan) }, "*");');
  b.push('  return true;');
  b.push('};');
  // p5 mendaftarkan penangan "load" lebih dahulu, sehingga setup() sudah selesai
  // ketika penangan di bawah ini berjalan. draw() baru mulai pada frame berikutnya.
  b.push('window.addEventListener("load", function () {');
  b.push('  SETELAH_SETUP = JSON.parse(JSON.stringify(TOTAL));');
  b.push('  setTimeout(function () {');
  b.push('    parent.postMessage({');
  b.push('      jenis: "selesai", total: TOTAL, setelahSetup: SETELAH_SETUP,');
  b.push('      adaKanvas: !!document.querySelector("canvas")');
  b.push('    }, "*");');
  b.push('  }, 450);');
  b.push('});');
  b.push('</scr' + 'ipt>');

  b.push('<scr' + 'ipt>');
  b.push('try {');
  b.push(kodePengguna);
  b.push('} catch (e) {');
  b.push('  parent.postMessage({ jenis: "galat", pesan: String(e.message || e) }, "*");');
  b.push('}');
  b.push('</scr' + 'ipt>');

  // Membungkus setup() dan draw() milik pengguna agar galat di dalamnya tertangkap.
  b.push('<scr' + 'ipt>');
  b.push('["setup", "draw"].forEach(function (nama) {');
  b.push('  var asli = window[nama];');
  b.push('  if (typeof asli !== "function") return;');
  b.push('  window[nama] = function () {');
  b.push('    try { return asli.apply(this, arguments); }');
  b.push('    catch (e) {');
  b.push('      parent.postMessage({ jenis: "galat", pesan: String(e.message || e) }, "*");');
  b.push('      if (typeof noLoop === "function") noLoop();');
  b.push('    }');
  b.push('  };');
  b.push('});');
  b.push('</scr' + 'ipt>');

  b.push('</body></html>');
  return b.join('\n');
}

function jalankanKode(tantangan) {
  const kode = $('editor').value;
  kodeDiedit[tantangan.id] = kode;
  menungguHasilKode = true;
  pesanKode('Menjalankan…', '');
  $('panggung').srcdoc = susunHalamanUji(kode);
}

window.addEventListener('message', (ev) => {
  const d = ev.data;
  if (!d || !d.jenis || !menungguHasilKode) return;

  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  const tantangan = db.tantanganLevel(level.id);
  if (!tantangan || tantangan.jenis !== 'koding') return;

  if (d.jenis === 'galat') {
    menungguHasilKode = false;
    pesanKode('Kodenya error: ' + d.pesan, 'gagal');
    pesanSoal('Perbaiki dahulu kesalahan pada kode, lalu jalankan lagi.', 'gagal');
    return;
  }
  if (d.jenis !== 'selesai') return;
  menungguHasilKode = false;

  pesanKode('Kode berhasil dijalankan.', 'lulus');
  terapkanHasil(tantangan, nilaiKoding(tantangan, {
    kode: $('editor').value,
    total: d.total || {},
    setelahSetup: d.setelahSetup || {},
    adaKanvas: !!d.adaKanvas,
  }));
});

/* ============ hasil penilaian dan gamifikasi ============ */

function terapkanHasil(tantangan, hasil) {
  if (!hasil.lulus) { pesanSoal(hasil.pesan, 'gagal'); return; }

  pesanSoal('Tantangan selesai. Jawabanmu sudah tepat.', 'lulus');

  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  if (progres.selesai.includes(level.id)) return;

  const sebelum = levelSekarang();
  progres.selesai.push(level.id);
  progres.xp += tantangan.xp;
  simpanProgres();
  gambarStatistik();
  gambarPeta();

  tampilkanNotifikasi(levelSekarang() > sebelum ? 'Naik ke level ' + levelSekarang() : '+' + tantangan.xp + ' XP');
}

function pesanSoal(teks, jenis) {
  const el = $('log-soal');
  el.hidden = !teks;
  el.textContent = teks;
  el.className = 'log' + (jenis ? ' ' + jenis : '');
}

function pesanKode(teks, jenis) {
  const el = $('log-kode');
  el.textContent = teks;
  el.className = 'log' + (jenis ? ' ' + jenis : '');
}

function tampilkanNotifikasi(teks) {
  const pop = $('pop');
  pop.textContent = teks;
  pop.classList.add('tampil');
  clearTimeout(pop.waktu);
  pop.waktu = setTimeout(() => pop.classList.remove('tampil'), 2200);
}

/* ============ alur tampilan ============ */

function gambarSemua() {
  gambarStatistik();
  gambarPeta();

  const materiTampil = tahap === 'materi';
  $('panel-materi').hidden = !materiTampil;
  $('area-tantangan').hidden = materiTampil;

  if (materiTampil) gambarMateri();
  else gambarTantangan();
}

$('tombol-mulai').onclick = () => { tahap = 'tantangan'; gambarSemua(); };
$('tombol-kembali').onclick = () => { tahap = 'materi'; gambarSemua(); };

$('tombol-reset').onclick = () => {
  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  const tantangan = db.tantanganLevel(level.id);
  delete kodeDiedit[tantangan.id];
  $('editor').value = tantangan.kode_awal || '';
  pesanSoal('', '');
  pesanKode('Kode dikembalikan ke contoh awal.', '');
};

$('tombol-kirim').onclick = () => {
  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  const tantangan = db.tantanganLevel(level.id);

  if (tantangan.jenis === 'pilihan_ganda') terapkanHasil(tantangan, nilaiPilihanGanda(tantangan));
  else if (tantangan.jenis === 'drag_drop') terapkanHasil(tantangan, nilaiDragDrop(tantangan));
  else jalankanKode(tantangan);
};

muatProgres();
if (!DATA.level.some((l) => l.id === progres.levelAktif)) progres.levelAktif = db.levelUrut()[0].id;
gambarSemua();
SKETSA_EOF

cat > README.md <<'SKETSA_EOF'
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
SKETSA_EOF

echo "Selesai. File yang dibuat:"
ls -1 index.html style.css data.js app.js README.md
echo ""
echo "Jalankan: python3 -m http.server 8080"
