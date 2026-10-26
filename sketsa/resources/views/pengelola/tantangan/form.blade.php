@extends('layouts.app')
@section('judul', 'Tantangan')

@section('isi')
<section class="panel">
  <div class="phead">
    <h3>Atur tantangan</h3>
    <span class="tag">{{ $level->judul }}</span>
  </div>

  <form method="POST" action="{{ route('pengelola.tantangan.update', $level) }}" class="form" id="form-tantangan">
    @csrf @method('PUT')

    <label>Bentuk tantangan
      <select name="jenis" id="pilih-jenis">
        <option value="pilihan_ganda" @selected(old('jenis', $tantangan->jenis) === 'pilihan_ganda')>Pilihan ganda</option>
        <option value="drag_drop" @selected(old('jenis', $tantangan->jenis) === 'drag_drop')>Susun urutan</option>
        <option value="koding" @selected(old('jenis', $tantangan->jenis) === 'koding')>Menulis kode</option>
      </select>
    </label>

    <label>Instruksi
      <textarea name="instruksi" required style="min-height:70px">{{ old('instruksi', $tantangan->instruksi) }}</textarea>
    </label>

    <label>XP
      <input type="number" name="xp" value="{{ old('xp', $tantangan->xp ?? 20) }}" min="0" required>
    </label>

    {{-- ---------- pilihan ganda dan susun urutan ---------- --}}
    <div id="bagian-item">
      <p style="margin:0;font-size:13px;color:var(--ink-2)">
        Pilihan jawaban (pilihan ganda) atau langkah yang harus disusun (susun urutan).
      </p>
      <div id="daftar-item" style="display:grid;gap:8px;margin-top:8px"></div>
      <div class="aksi"><button type="button" class="btn samar" id="tambah-item">Tambah baris</button></div>
    </div>

    {{-- ---------- koding ---------- --}}
    <div id="bagian-koding">
      <label>Kode awal
        <textarea name="kode_awal">{{ old('kode_awal', $tantangan->kode_awal) }}</textarea>
      </label>

      <p style="margin:0;font-size:13px;color:var(--ink-2)">
        Kriteria penilaian. Aturan diperiksa berurutan dan berhenti pada aturan pertama yang gagal.
      </p>
      <div id="daftar-aturan" style="display:grid;gap:8px;margin-top:8px"></div>
      <div class="aksi"><button type="button" class="btn samar" id="tambah-aturan">Tambah aturan</button></div>
    </div>

    @foreach ($errors->all() as $pesan)
      <p class="galat">{{ $pesan }}</p>
    @endforeach

    <div class="aksi">
      <button class="btn utama">Simpan</button>
      <a class="btn samar" href="{{ route('pengelola.materi.index') }}">Batal</a>
    </div>
  </form>
</section>
@endsection

@push('skrip')
<script>
const ITEM_AWAL = @json($tantangan->exists ? $tantangan->item->map(fn ($i) => [
    'konten' => $i->konten, 'benar' => (bool) $i->benar, 'urutan_benar' => $i->urutan_benar,
]) : []);

const ATURAN_AWAL = @json($tantangan->exists ? $tantangan->aturan->map(fn ($a) => [
    'jenis_aturan' => $a->jenis_aturan, 'target' => $a->target, 'cakupan' => $a->cakupan,
    'operator' => $a->operator, 'nilai' => $a->nilai, 'pesan_gagal' => $a->pesan_gagal,
]) : []);

const daftarItem = document.getElementById('daftar-item');
const daftarAturan = document.getElementById('daftar-aturan');
const pilihJenis = document.getElementById('pilih-jenis');

function barisItem(i, isi = {}) {
  const d = document.createElement('div');
  d.className = 'baris-item';
  d.innerHTML = `
    <label>Teks
      <input type="text" name="item[${i}][konten]" value="${(isi.konten ?? '').replace(/"/g, '&quot;')}" required>
    </label>
    <label class="hanya-pg">Jawaban benar
      <select name="item[${i}][benar]">
        <option value="0">Tidak</option>
        <option value="1" ${isi.benar ? 'selected' : ''}>Ya</option>
      </select>
    </label>
    <label class="hanya-dd">Urutan benar
      <input type="number" name="item[${i}][urutan_benar]" value="${isi.urutan_benar ?? i + 1}" min="1">
    </label>`;
  const hapus = document.createElement('button');
  hapus.type = 'button';
  hapus.className = 'btn samar';
  hapus.textContent = 'Hapus baris';
  hapus.onclick = () => { d.remove(); nomoriUlang(); };
  d.appendChild(hapus);
  return d;
}

function barisAturan(i, isi = {}) {
  const pilih = (nilai, daftar) => daftar
    .map(([v, t]) => `<option value="${v}" ${nilai === v ? 'selected' : ''}>${t}</option>`).join('');

  const d = document.createElement('div');
  d.className = 'baris-aturan';
  d.innerHTML = `
    <label>Jenis aturan
      <select name="aturan[${i}][jenis_aturan]">
        ${pilih(isi.jenis_aturan, [
          ['kanvas_terbentuk', 'Kanvas harus terbentuk'],
          ['mengandung_teks', 'Kode harus memuat teks'],
          ['tidak_mengandung', 'Kode tidak boleh memuat teks'],
          ['jumlah_panggil', 'Jumlah pemanggilan fungsi'],
        ])}
      </select>
    </label>
    <label>Target (kata kunci atau nama fungsi)
      <input type="text" name="aturan[${i}][target]" value="${(isi.target ?? '').replace(/"/g, '&quot;')}">
    </label>
    <label>Cakupan
      <select name="aturan[${i}][cakupan]">
        <option value="">—</option>
        ${pilih(isi.cakupan, [['setup', 'setup'], ['draw', 'draw'], ['semua', 'semua']])}
      </select>
    </label>
    <label>Operator dan nilai
      <span style="display:flex;gap:6px">
        <select name="aturan[${i}][operator]" style="flex:1">
          <option value="">—</option>
          ${pilih(isi.operator, [['=', '='], ['>=', '>='], ['<=', '<=']])}
        </select>
        <input type="number" name="aturan[${i}][nilai]" value="${isi.nilai ?? ''}" style="flex:1">
      </span>
    </label>
    <label style="grid-column:1/-1">Pesan bila gagal
      <input type="text" name="aturan[${i}][pesan_gagal]" value="${(isi.pesan_gagal ?? '').replace(/"/g, '&quot;')}" required>
    </label>`;
  const hapus = document.createElement('button');
  hapus.type = 'button';
  hapus.className = 'btn samar';
  hapus.textContent = 'Hapus aturan';
  hapus.onclick = () => { d.remove(); nomoriUlang(); };
  d.appendChild(hapus);
  return d;
}

// Menomori ulang nama input agar indeksnya tetap berurutan setelah ada yang dihapus.
function nomoriUlang() {
  [['item', daftarItem], ['aturan', daftarAturan]].forEach(([awalan, wadah]) => {
    [...wadah.children].forEach((baris, i) => {
      baris.querySelectorAll('[name]').forEach((kolom) => {
        kolom.name = kolom.name.replace(new RegExp('^' + awalan + '\\[\\d+\\]'), awalan + '[' + i + ']');
      });
    });
  });
}

function perbaruiTampilan() {
  const jenis = pilihJenis.value;
  document.getElementById('bagian-item').hidden = jenis === 'koding';
  document.getElementById('bagian-koding').hidden = jenis !== 'koding';
  document.querySelectorAll('.hanya-pg').forEach((e) => { e.hidden = jenis !== 'pilihan_ganda'; });
  document.querySelectorAll('.hanya-dd').forEach((e) => { e.hidden = jenis !== 'drag_drop'; });
}

document.getElementById('tambah-item').onclick = () => {
  daftarItem.appendChild(barisItem(daftarItem.children.length));
  perbaruiTampilan();
};
document.getElementById('tambah-aturan').onclick = () => {
  daftarAturan.appendChild(barisAturan(daftarAturan.children.length));
};

ITEM_AWAL.forEach((isi, i) => daftarItem.appendChild(barisItem(i, isi)));
ATURAN_AWAL.forEach((isi, i) => daftarAturan.appendChild(barisAturan(i, isi)));
pilihJenis.addEventListener('change', perbaruiTampilan);
perbaruiTampilan();
</script>
@endpush
