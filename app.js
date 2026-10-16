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
