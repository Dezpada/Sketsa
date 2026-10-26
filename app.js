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
let batasTunggu = null;
// Menandai tantangan mana yang kodenya sedang dijalankan, agar hasil yang
// datang terlambat tidak dinilai untuk tantangan yang sudah berganti.
let tantanganBerjalan = null;

const HALAMAN_KOSONG =
  '<!DOCTYPE html><html><head><meta charset="utf-8">' +
  '<style>html,body{margin:0;padding:0;background:#0a0e1a}</style>' +
  '</head><body></body></html>';

// Mengosongkan panggung hasil beserta keadaan jalannya kode.
function bersihkanPanggung() {
  menungguHasilKode = false;
  tantanganBerjalan = null;
  $('panggung').srcdoc = HALAMAN_KOSONG;
  pesanKode('Tekan Jalankan untuk melihat hasilnya.', '');
}

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
  bersihkanPanggung();

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
  tantanganBerjalan = tantangan.id;
  pesanKode('Menjalankan…', '');
  pesanSoal('', '');
  $('panggung').srcdoc = susunHalamanUji(kode);

  // Bila tidak ada kabar sama sekali, kemungkinan besar pustaka p5.js
  // gagal diunduh. Tanpa penjagaan ini aplikasi akan diam tanpa pesan.
  clearTimeout(batasTunggu);
  batasTunggu = setTimeout(function () {
    if (!menungguHasilKode) return;
    menungguHasilKode = false;
    pesanKode('Pustaka p5.js gagal dimuat dari internet.', 'gagal');
    pesanSoal('Kode tidak dapat dijalankan karena p5.js gagal dimuat. Periksa koneksi internet, atau simpan p5.js secara lokal (lihat README).', 'gagal');
  }, 8000);
}

window.addEventListener('message', (ev) => {
  const d = ev.data;
  if (!d || !d.jenis || !menungguHasilKode) return;
  clearTimeout(batasTunggu);

  const level = DATA.level.find((l) => l.id === progres.levelAktif);
  const tantangan = db.tantanganLevel(level.id);
  if (!tantangan || tantangan.jenis !== 'koding' || tantangan.id !== tantanganBerjalan) {
    menungguHasilKode = false;
    return;
  }

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
