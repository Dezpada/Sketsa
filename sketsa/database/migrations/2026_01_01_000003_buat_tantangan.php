<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tantangan', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('level_id')->constrained('level')->cascadeOnDelete();
            $tabel->enum('jenis', ['pilihan_ganda', 'drag_drop', 'koding']);
            $tabel->text('instruksi');
            $tabel->longText('kode_awal')->nullable();
            $tabel->unsignedInteger('xp')->default(10);
            $tabel->unsignedInteger('urutan')->default(1);
            $tabel->timestamps();
        });

        // Dipakai pilihan ganda (kolom benar) dan drag and drop (kolom urutan_benar).
        Schema::create('tantangan_item', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('tantangan_id')->constrained('tantangan')->cascadeOnDelete();
            $tabel->text('konten');
            $tabel->boolean('benar')->nullable();
            $tabel->unsignedInteger('urutan_benar')->nullable();
            $tabel->unsignedInteger('urutan_tampil')->default(1);
            $tabel->timestamps();
        });

        // Kriteria penilaian tantangan koding, disusun pengelola lewat formulir.
        Schema::create('tantangan_aturan', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('tantangan_id')->constrained('tantangan')->cascadeOnDelete();
            $tabel->enum('jenis_aturan', [
                'kanvas_terbentuk', 'mengandung_teks', 'tidak_mengandung', 'jumlah_panggil',
            ]);
            $tabel->string('target')->nullable();
            $tabel->enum('cakupan', ['setup', 'draw', 'semua'])->nullable();
            $tabel->enum('operator', ['=', '>=', '<='])->nullable();
            $tabel->integer('nilai')->nullable();
            $tabel->text('pesan_gagal');
            $tabel->unsignedInteger('urutan')->default(1);
            $tabel->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tantangan_aturan');
        Schema::dropIfExists('tantangan_item');
        Schema::dropIfExists('tantangan');
    }
};
