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
    <div id="daftar-misi"></div>
  </nav>

  <div class="kerja">

    <div class="kolom">
      <section class="panel">
        <div class="phead">
          <h3 id="judul-misi">Memuat…</h3>
          <span class="tag" id="tag-misi"></span>
        </div>
        <div class="brief" id="brief-misi"></div>
      </section>

      <section class="panel">
        <div class="phead">
          <h3>Kode kamu</h3>
          <span class="tag">JavaScript · p5.js</span>
        </div>
        <textarea id="editor" class="editor" spellcheck="false" aria-label="Editor kode"></textarea>
        <div class="aksi">
          <button id="tombol-jalankan" class="btn utama">Jalankan</button>
          <button id="tombol-reset" class="btn samar">Kembalikan kode awal</button>
          <span class="petunjuk" id="petunjuk-misi"></span>
        </div>
      </section>
    </div>

    <section class="panel">
      <div class="phead">
        <h3>Hasil</h3>
        <span class="tag">iframe sandbox</span>
      </div>
      <div class="panggung">
        <iframe id="panggung" title="Hasil kode" sandbox="allow-scripts"></iframe>
      </div>
      <div class="log" id="log">Tekan Jalankan untuk melihat hasilnya.</div>
    </section>

  </div>
</main>

<div class="pop" id="pop" role="status" aria-live="polite"></div>

<script src="levels.js"></script>
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
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  gap: 14px;
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
  display: inline-grid;
  place-items: center;
  min-width: 26px;
  height: 26px;
  padding: 0 7px;
  border-radius: 7px;
  background: var(--amber);
  color: #412402;
  font-weight: 700;
  font-size: 13px;
}

.xpwrap { width: 150px; }
.xptrack { height: 4px; border-radius: 2px; background: var(--line); overflow: hidden; }
.xpfill { height: 100%; width: 0; background: var(--amber); transition: width 0.45s ease; }
.xpnum { margin-top: 4px; font-size: 11.5px; color: var(--ink-2); font-family: ui-monospace, monospace; }

/* ---------- tata letak ---------- */
.wrap {
  max-width: 1180px;
  margin: 0 auto;
  padding: 16px;
  display: grid;
  gap: 16px;
}

@media (min-width: 980px) {
  .wrap { grid-template-columns: 230px 1fr; align-items: start; }
  .peta { position: sticky; top: 86px; }
  .kerja { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; align-items: start; }
}

.kolom { display: grid; gap: 16px; align-content: start; }

/* ---------- peta misi ---------- */
.peta {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 8px;
}

.peta h2 { margin: 6px 8px 8px; font-size: 12.5px; font-weight: 500; color: var(--ink-2); }

.misi {
  display: flex;
  gap: 10px;
  align-items: flex-start;
  width: 100%;
  padding: 9px;
  border: 0;
  border-radius: 9px;
  background: none;
  color: var(--ink);
  font: inherit;
  font-size: 14px;
  text-align: left;
  cursor: pointer;
}

.misi:hover { background: var(--surface-2); }
.misi[aria-current="true"] { background: var(--surface-2); box-shadow: inset 2px 0 0 var(--amber); }
.misi:focus-visible { outline: 2px solid var(--amber); outline-offset: 1px; }

.misi i {
  min-width: 16px;
  padding-top: 1px;
  font-style: normal;
  font-family: ui-monospace, monospace;
  font-size: 12px;
  color: var(--ink-2);
}

.misi.selesai i { color: var(--teal); }
.misi em { display: block; font-style: normal; font-size: 11.5px; color: var(--ink-2); }

/* ---------- panel ---------- */
.panel {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  overflow: hidden;
}

.phead {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 11px 14px;
  border-bottom: 1px solid var(--line);
}

.phead h3 { margin: 0; font-size: 14px; font-weight: 500; }
.phead .tag { margin-left: auto; font-family: ui-monospace, monospace; font-size: 11px; color: var(--ink-2); }

.brief { padding: 13px 14px; font-size: 14px; }
.brief p { margin: 0 0 8px; }
.brief p:last-child { margin-bottom: 0; }
.brief code {
  padding: 1.5px 5px;
  border-radius: 5px;
  background: var(--surface-2);
  font-family: ui-monospace, monospace;
  font-size: 12.5px;
}

/* ---------- editor ---------- */
.editor {
  display: block;
  width: 100%;
  min-height: 260px;
  padding: 13px 14px;
  border: 0;
  resize: vertical;
  background: var(--panggung);
  color: #d7dcf0;
  font-family: ui-monospace, "SF Mono", Menlo, monospace;
  font-size: 13px;
  line-height: 1.65;
  tab-size: 2;
}

.editor:focus { outline: 2px solid var(--amber); outline-offset: -2px; }

.aksi {
  display: flex;
  align-items: center;
  gap: 9px;
  padding: 11px 14px;
  border-top: 1px solid var(--line);
  flex-wrap: wrap;
}

.btn {
  padding: 8px 15px;
  border: 1px solid transparent;
  border-radius: 8px;
  font: inherit;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
}

.btn:focus-visible { outline: 2px solid var(--amber); outline-offset: 2px; }
.utama { background: var(--amber); color: #412402; }
.utama:hover { filter: brightness(1.07); }
.samar { background: transparent; color: var(--ink-2); border-color: var(--line); }
.samar:hover { color: var(--ink); border-color: var(--ink-2); }

.petunjuk { margin-left: auto; font-size: 12.5px; color: var(--ink-2); }

/* ---------- panggung hasil ---------- */
.panggung {
  display: grid;
  place-items: center;
  padding: 16px;
  min-height: 300px;
  background: var(--panggung);
}

.panggung iframe {
  width: 320px;
  height: 320px;
  max-width: 100%;
  border: 0;
  border-radius: 8px;
  background: #0a0e1a;
  display: block;
}

.log {
  min-height: 34px;
  padding: 9px 14px;
  border-top: 1px solid var(--line);
  background: var(--panggung);
  color: #8b93ad;
  font-family: ui-monospace, monospace;
  font-size: 12px;
}

.log.gagal { color: var(--merah); }
.log.lulus { color: var(--teal); }

/* ---------- notifikasi ---------- */
.pop {
  position: fixed;
  left: 50%;
  bottom: 22px;
  z-index: 50;
  padding: 11px 20px;
  border-radius: 999px;
  background: var(--amber);
  color: #412402;
  font-weight: 700;
  font-size: 14px;
  transform: translate(-50%, 160%);
  transition: transform 0.45s cubic-bezier(0.2, 1.3, 0.4, 1);
  box-shadow: 0 6px 24px rgba(0, 0, 0, 0.28);
}

.pop.tampil { transform: translate(-50%, 0); }

@media (prefers-reduced-motion: reduce) {
  .pop, .xpfill { transition: none; }
}
SKETSA_EOF

cat > levels.js <<'SKETSA_EOF'
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
SKETSA_EOF

cat > app.js <<'SKETSA_EOF'
// Mesin aplikasi: memuat misi, menjalankan kode pengguna, menilai, dan mengatur gamifikasi.

const ALAMAT_P5 = 'https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js';
const KUNCI_SIMPAN = 'sketsa.progres.v1';
const XP_PER_LEVEL = 100;

// Fungsi p5 yang dihitung pemanggilannya untuk keperluan penilaian.
const FUNGSI_DIHITUNG = [
  'circle', 'ellipse', 'rect', 'square', 'line', 'triangle',
  'point', 'arc', 'text', 'fill', 'background', 'createCanvas'
];

let progres = { xp: 0, selesai: [], misiAktif: 0 };
const kodeDiedit = {};   // kode yang sedang diketik, per misi
let menungguHasil = false;

const $ = (id) => document.getElementById(id);

/* ---------- penyimpanan progres ---------- */
// Di aplikasi sebenarnya bagian ini diganti dengan pemanggilan API ke Laravel.

function muatProgres() {
  try {
    const tersimpan = localStorage.getItem(KUNCI_SIMPAN);
    if (!tersimpan) return;
    const data = JSON.parse(tersimpan);
    progres = {
      xp: data.xp || 0,
      selesai: Array.isArray(data.selesai) ? data.selesai : [],
      misiAktif: data.misiAktif || 0
    };
  } catch (e) {
    // Penyimpanan tidak tersedia, mulai dari nol.
  }
}

function simpanProgres() {
  try {
    localStorage.setItem(KUNCI_SIMPAN, JSON.stringify(progres));
  } catch (e) {
    // Diabaikan: aplikasi tetap berjalan tanpa penyimpanan.
  }
}

/* ---------- tampilan ---------- */

function levelSekarang() {
  return Math.floor(progres.xp / XP_PER_LEVEL) + 1;
}

function gambarStatistik() {
  const sisa = progres.xp % XP_PER_LEVEL;
  $('level').textContent = levelSekarang();
  $('xp-fill').style.width = sisa + '%';
  $('xp-num').textContent = progres.xp + ' XP · ' + (XP_PER_LEVEL - sisa) + ' lagi';
}

function gambarDaftarMisi() {
  const wadah = $('daftar-misi');
  wadah.innerHTML = '';

  DAFTAR_MISI.forEach((misi, nomor) => {
    const tombol = document.createElement('button');
    const sudahSelesai = progres.selesai.includes(misi.id);

    tombol.className = 'misi' + (sudahSelesai ? ' selesai' : '');
    if (nomor === progres.misiAktif) tombol.setAttribute('aria-current', 'true');

    const tanda = document.createElement('i');
    tanda.textContent = sudahSelesai ? '✓' : String(nomor + 1);

    const teks = document.createElement('span');
    teks.textContent = misi.judul;
    const bab = document.createElement('em');
    bab.textContent = misi.bab + ' · ' + misi.xp + ' XP';
    teks.appendChild(bab);

    tombol.append(tanda, teks);
    tombol.onclick = () => {
      progres.misiAktif = nomor;
      simpanProgres();
      gambarSemua();
      jalankanKode();
    };

    wadah.appendChild(tombol);
  });
}

function gambarMisi() {
  const misi = DAFTAR_MISI[progres.misiAktif];
  $('judul-misi').textContent = misi.judul;
  $('tag-misi').textContent = 'Misi ' + (progres.misiAktif + 1) + ' dari ' + DAFTAR_MISI.length;
  $('brief-misi').innerHTML = misi.brief;
  $('petunjuk-misi').textContent = misi.petunjuk;
  $('editor').value = (progres.misiAktif in kodeDiedit)
    ? kodeDiedit[progres.misiAktif]
    : misi.kode;
}

function gambarSemua() {
  gambarStatistik();
  gambarDaftarMisi();
  gambarMisi();
  tulisLog('Tekan Jalankan untuk melihat hasilnya.', '');
}

function tulisLog(pesan, jenis) {
  const el = $('log');
  el.textContent = pesan;
  el.className = 'log' + (jenis ? ' ' + jenis : '');
}

function tampilkanNotifikasi(teks) {
  const pop = $('pop');
  pop.textContent = teks;
  pop.classList.add('tampil');
  clearTimeout(pop.waktu);
  pop.waktu = setTimeout(() => pop.classList.remove('tampil'), 2200);
}

/* ---------- menjalankan kode pengguna ---------- */

// Kode pengguna dijalankan di dalam iframe ber-sandbox supaya terpisah
// dari halaman utama. Sebelum p5 membuat instansinya, fungsi-fungsi
// gambar dibungkus agar jumlah pemanggilannya bisa dihitung untuk penilaian.

function susunHalamanUji(kodePengguna) {
  const daftar = JSON.stringify(FUNGSI_DIHITUNG);
  const bagian = [];

  bagian.push('<!DOCTYPE html><html><head><meta charset="utf-8">');
  bagian.push('<style>html,body{margin:0;padding:0;overflow:hidden;background:#0a0e1a}canvas{display:block}</style>');
  bagian.push('<scr' + 'ipt src="' + ALAMAT_P5 + '"></scr' + 'ipt>');
  bagian.push('</head><body>');

  // Pembungkus penghitung. Dijalankan setelah p5 dimuat, sebelum instansinya dibuat.
  bagian.push('<scr' + 'ipt>');
  bagian.push('var TOTAL = {}, SETELAH_SETUP = {};');
  bagian.push('(function () {');
  bagian.push('  ' + daftar + '.forEach(function (nama) {');
  bagian.push('    var asli = p5.prototype[nama];');
  bagian.push('    if (!asli) return;');
  bagian.push('    p5.prototype[nama] = function () {');
  bagian.push('      TOTAL[nama] = (TOTAL[nama] || 0) + 1;');
  bagian.push('      return asli.apply(this, arguments);');
  bagian.push('    };');
  bagian.push('  });');
  bagian.push('})();');
  bagian.push('window.onerror = function (pesan) {');
  bagian.push('  parent.postMessage({ jenis: "galat", pesan: String(pesan) }, "*");');
  bagian.push('  return true;');
  bagian.push('};');
  // p5 mendaftarkan penangan "load" lebih dahulu, sehingga setup() sudah selesai
  // ketika penangan di bawah ini berjalan. draw() baru mulai pada frame berikutnya.
  bagian.push('window.addEventListener("load", function () {');
  bagian.push('  SETELAH_SETUP = JSON.parse(JSON.stringify(TOTAL));');
  bagian.push('  setTimeout(function () {');
  bagian.push('    parent.postMessage({');
  bagian.push('      jenis: "selesai",');
  bagian.push('      total: TOTAL,');
  bagian.push('      setelahSetup: SETELAH_SETUP,');
  bagian.push('      adaKanvas: !!document.querySelector("canvas")');
  bagian.push('    }, "*");');
  bagian.push('  }, 450);');
  bagian.push('});');
  bagian.push('</scr' + 'ipt>');

  // Kode pengguna.
  bagian.push('<scr' + 'ipt>');
  bagian.push('try {');
  bagian.push(kodePengguna);
  bagian.push('} catch (e) {');
  bagian.push('  parent.postMessage({ jenis: "galat", pesan: String(e.message || e) }, "*");');
  bagian.push('}');
  bagian.push('</scr' + 'ipt>');

  // Membungkus setup() dan draw() milik pengguna agar error di dalamnya tertangkap.
  // p5 membaca kedua fungsi ini saat halaman selesai dimuat, jadi pembungkusan
  // di sini tetap terbaca oleh p5.
  bagian.push('<scr' + 'ipt>');
  bagian.push('["setup", "draw"].forEach(function (nama) {');
  bagian.push('  var asli = window[nama];');
  bagian.push('  if (typeof asli !== "function") return;');
  bagian.push('  window[nama] = function () {');
  bagian.push('    try {');
  bagian.push('      return asli.apply(this, arguments);');
  bagian.push('    } catch (e) {');
  bagian.push('      parent.postMessage({ jenis: "galat", pesan: String(e.message || e) }, "*");');
  bagian.push('      if (typeof noLoop === "function") noLoop();');
  bagian.push('    }');
  bagian.push('  };');
  bagian.push('});');
  bagian.push('</scr' + 'ipt>');

  bagian.push('</body></html>');
  return bagian.join('\n');
}

function jalankanKode() {
  const kode = $('editor').value;
  kodeDiedit[progres.misiAktif] = kode;
  menungguHasil = true;
  tulisLog('Menjalankan…', '');
  $('panggung').srcdoc = susunHalamanUji(kode);
}

/* ---------- menerima hasil dan menilai ---------- */

window.addEventListener('message', (peristiwa) => {
  const data = peristiwa.data;
  if (!data || !data.jenis || !menungguHasil) return;

  if (data.jenis === 'galat') {
    menungguHasil = false;
    tulisLog('Kodenya error: ' + data.pesan, 'gagal');
    return;
  }

  if (data.jenis !== 'selesai') return;
  menungguHasil = false;

  const misi = DAFTAR_MISI[progres.misiAktif];
  const hasil = misi.periksa({
    kode: $('editor').value,
    total: data.total || {},
    setelahSetup: data.setelahSetup || {},
    adaKanvas: !!data.adaKanvas
  });

  if (!hasil.lulus) {
    tulisLog(hasil.pesan, 'gagal');
    return;
  }

  tulisLog('Misi selesai. Hasilmu sudah sesuai.', 'lulus');
  if (progres.selesai.includes(misi.id)) return;

  const levelSebelum = levelSekarang();
  progres.selesai.push(misi.id);
  progres.xp += misi.xp;
  simpanProgres();
  gambarStatistik();
  gambarDaftarMisi();

  tampilkanNotifikasi(
    levelSekarang() > levelSebelum
      ? 'Naik ke level ' + levelSekarang()
      : '+' + misi.xp + ' XP'
  );
});

/* ---------- tombol dan pintasan ---------- */

$('tombol-jalankan').onclick = jalankanKode;

$('tombol-reset').onclick = () => {
  delete kodeDiedit[progres.misiAktif];
  $('editor').value = DAFTAR_MISI[progres.misiAktif].kode;
  tulisLog('Kode dikembalikan ke contoh awal.', '');
};

// Tombol Tab menyisipkan spasi, bukan memindahkan fokus.
$('editor').addEventListener('keydown', (e) => {
  if (e.key === 'Tab') {
    e.preventDefault();
    const area = e.target;
    const posisi = area.selectionStart;
    area.value = area.value.slice(0, posisi) + '  ' + area.value.slice(area.selectionEnd);
    area.selectionStart = area.selectionEnd = posisi + 2;
  }
});

/* ---------- mulai ---------- */

muatProgres();
if (progres.misiAktif >= DAFTAR_MISI.length) progres.misiAktif = 0;
gambarSemua();
jalankanKode();
SKETSA_EOF

cat > README.md <<'SKETSA_EOF'
# Sketsa — purwarupa aplikasi pembelajaran koding

Purwarupa aplikasi pembelajaran koding berbasis gamifikasi menggunakan p5.js
sebagai media pembelajaran visual. Dibuat sebagai bahan Tugas Akhir.

## Cara menjalankan

Di terminal Codespaces, jalankan:

```bash
python3 -m http.server 8080
```

Codespaces akan menampilkan notifikasi untuk membuka port 8080 di peramban.
Jika tidak muncul, buka tab **PORTS**, cari baris 8080, lalu tekan ikon globe.

Untuk menghentikan server, tekan `Ctrl + C` di terminal.

## Isi file

| File | Isi |
| --- | --- |
| `index.html` | Kerangka halaman |
| `style.css` | Tampilan |
| `levels.js` | **Data misi.** Di sinilah materi dan penilaian ditulis |
| `app.js` | Mesin aplikasi: menjalankan kode, menilai, mengatur XP |

## Menambah misi baru

Buka `levels.js`, tambahkan satu objek pada array `DAFTAR_MISI`:

```js
{
  id: 'nama-unik',
  judul: 'Judul misi',
  bab: 'Nama bab',
  xp: 30,
  brief: '<p>Instruksi untuk pengguna.</p>',
  petunjuk: 'teks pendek',
  kode: 'function setup() {\n  createCanvas(320, 320);\n}',
  periksa(data) {
    if (!data.adaKanvas) {
      return { lulus: false, pesan: 'Kanvas belum terbentuk.' };
    }
    return { lulus: true };
  }
}
```

Data yang diterima `periksa`:

- `kode` — teks kode yang ditulis pengguna
- `setelahSetup` — jumlah pemanggilan tiap fungsi p5 sampai `setup()` selesai
- `total` — jumlah pemanggilan sampai pemeriksaan dilakukan
- `adaKanvas` — `true` jika kanvas berhasil dibuat

Selisih `total` dan `setelahSetup` menunjukkan berapa kali sebuah fungsi
dipanggil di dalam `draw()`, sehingga animasi bisa dideteksi.

## Catatan

Kode pengguna dijalankan di dalam `iframe` ber-`sandbox` agar terpisah dari
halaman utama aplikasi.

Progres saat ini disimpan di `localStorage` peramban. Pada aplikasi sebenarnya,
bagian ini diganti dengan pemanggilan API ke Laravel — lihat fungsi
`muatProgres()` dan `simpanProgres()` di `app.js`.

Purwarupa ini belum mencakup akun pengguna, papan peringkat antar pengguna,
dan galeri karya.
SKETSA_EOF

echo "Selesai. File yang dibuat:"
ls -1 index.html style.css levels.js app.js README.md
echo ""
echo "Jalankan: python3 -m http.server 8080"
