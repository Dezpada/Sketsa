// Menangani ketiga bentuk tantangan di sisi peserta, lalu mengirim
// jawaban ke server untuk dinilai.
//
// Penilaian tidak dilakukan di berkas ini. Berkas ini hanya mengumpulkan
// jawaban, termasuk hasil menjalankan kode, lalu mengirimkannya.

(function () {
  const ALAMAT_P5 = 'https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js';
  const FUNGSI_DIHITUNG = [
    'circle', 'ellipse', 'rect', 'square', 'line', 'triangle',
    'point', 'arc', 'text', 'fill', 'background', 'createCanvas'
  ];

  const wadah = document.getElementById('isi-soal');
  if (!wadah) return;

  const jenis = wadah.dataset.jenis;
  const alamatKirim = wadah.dataset.kirim;
  const token = document.querySelector('meta[name="csrf-token"]').content;

  const $ = (id) => document.getElementById(id);
  let menunggu = false;

  /* ---------------- pesan ---------------- */

  function pesanSoal(teks, kelas) {
    const el = $('log-soal');
    el.hidden = !teks;
    el.textContent = teks;
    el.className = 'log' + (kelas ? ' ' + kelas : '');
  }

  function pesanKode(teks, kelas) {
    const el = $('log-kode');
    if (!el) return;
    el.textContent = teks;
    el.className = 'log' + (kelas ? ' ' + kelas : '');
  }
  function tampilkanLanjut(lanjut) {
    const kotak = $('aksi-lanjut');
    const tombol = $('tombol-lanjut');
    if (!kotak || !tombol) return;

    if (!lanjut || !lanjut.url) {
      kotak.hidden = true;
      return;
    }

    tombol.textContent = lanjut.label;
    tombol.href = lanjut.url;
    kotak.hidden = false;
  }

  function notifikasi(teks) {
    const pop = $('pop');
    pop.textContent = teks;
    pop.classList.add('tampil');
    clearTimeout(pop.waktu);
    pop.waktu = setTimeout(() => pop.classList.remove('tampil'), 2200);
  }

  /* ---------------- pilihan ganda ---------------- */

  if (jenis === 'pilihan_ganda') {
    wadah.querySelectorAll('.opsi').forEach((tombol) => {
      tombol.addEventListener('click', () => {
        wadah.querySelectorAll('.opsi').forEach((o) => o.setAttribute('aria-pressed', 'false'));
        tombol.setAttribute('aria-pressed', 'true');
      });
    });
  }

  /* ---------------- susun urutan ---------------- */

  function perbaruiNomor(ul) {
    [...ul.children].forEach((li, i) => {
      li.querySelector('.nomor').textContent = String(i + 1);
    });
  }

  if (jenis === 'drag_drop') {
    const ul = wadah.querySelector('.urut-list');
    perbaruiNomor(ul);

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
      ul.insertBefore(seret, e.clientY > kotak.top + kotak.height / 2 ? li.nextSibling : li);
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

  /* ---------------- editor kode ---------------- */

  if (jenis === 'koding') {
    const editor = $('editor');

    editor.addEventListener('keydown', (e) => {
      if (e.key !== 'Tab') return;
      e.preventDefault();
      const p = editor.selectionStart;
      editor.value = editor.value.slice(0, p) + '  ' + editor.value.slice(editor.selectionEnd);
      editor.selectionStart = editor.selectionEnd = p + 2;
    });

    const reset = $('tombol-reset');
    if (reset) {
      reset.addEventListener('click', () => {
        editor.value = editor.dataset.awal || '';
        pesanSoal('', '');
        pesanKode('Kode dikembalikan ke contoh awal.', '');
      });
    }
  }

  /* ---------------- menjalankan kode ---------------- */

  function susunHalamanUji(kode) {
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
    b.push('window.addEventListener("load", function () {');
    b.push('  SETELAH_SETUP = JSON.parse(JSON.stringify(TOTAL));');
    b.push('  setTimeout(function () {');
    b.push('    parent.postMessage({ jenis: "selesai", total: TOTAL, setelahSetup: SETELAH_SETUP,');
    b.push('      adaKanvas: !!document.querySelector("canvas") }, "*");');
    b.push('  }, 450);');
    b.push('});');
    b.push('</scr' + 'ipt>');

    b.push('<scr' + 'ipt>');
    b.push('try {');
    b.push(kode);
    b.push('} catch (e) {');
    b.push('  parent.postMessage({ jenis: "galat", pesan: String(e.message || e) }, "*");');
    b.push('}');
    b.push('</scr' + 'ipt>');

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

  window.addEventListener('message', (ev) => {
    const d = ev.data;
    if (!d || !d.jenis || !menunggu) return;

    if (d.jenis === 'galat') {
      menunggu = false;
      pesanKode('Kodenya error: ' + d.pesan, 'gagal');
      pesanSoal('Perbaiki dahulu kesalahan pada kode, lalu jalankan lagi.', 'gagal');
      return;
    }
    if (d.jenis !== 'selesai') return;

    menunggu = false;
    pesanKode('Kode berhasil dijalankan.', 'lulus');

    kirim({
      kode: $('editor').value,
      total: d.total || {},
      setelah_setup: d.setelahSetup || {},
      ada_kanvas: !!d.adaKanvas,
    });
  });

  /* ---------------- pengiriman jawaban ---------------- */

  async function kirim(jawaban) {
    try {
      const balasan = await fetch(alamatKirim, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': token,
          'Accept': 'application/json',
        },
        body: JSON.stringify(jawaban),
      });

      if (!balasan.ok) {
        pesanSoal('Gagal mengirim jawaban ke server. Coba lagi.', 'gagal');
        return;
      }

      const hasil = await balasan.json();
      pesanSoal(hasil.pesan, hasil.lulus ? 'lulus' : 'gagal');
      tampilkanLanjut(hasil.lanjut);

      if (hasil.lulus && hasil.xp_diperoleh > 0) {
        notifikasi('+' + hasil.xp_diperoleh + ' XP');
        const xp = $('xp-num');
        if (xp) xp.textContent = hasil.total_xp + ' XP';
      }
    } catch (e) {
      pesanSoal('Tidak dapat menghubungi server. Periksa sambungan, lalu coba lagi.', 'gagal');
    }
  }

  /* ---------------- tombol kirim ---------------- */

  $('tombol-kirim').addEventListener('click', () => {
    tampilkanLanjut(null);
    
    if (jenis === 'pilihan_ganda') {
      const dipilih = wadah.querySelector('.opsi[aria-pressed="true"]');
      kirim({ item_id: dipilih ? Number(dipilih.dataset.itemId) : null });
      return;
    }

    if (jenis === 'drag_drop') {
      const urutan = [...wadah.querySelectorAll('.urut')].map((li) => Number(li.dataset.itemId));
      kirim({ urutan });
      return;
    }

    menunggu = true;
    pesanSoal('', '');
    pesanKode('Menjalankan…', '');
    $('panggung').srcdoc = susunHalamanUji($('editor').value);
  });
})();
