<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('modul', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->string('nama');
            $tabel->unsignedInteger('urutan')->default(1);
            $tabel->timestamps();
        });

        Schema::create('level', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('modul_id')->constrained('modul')->cascadeOnDelete();
            $tabel->string('judul');
            $tabel->unsignedInteger('urutan')->default(1);
            $tabel->timestamps();
        });

        Schema::create('materi', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('level_id')->constrained('level')->cascadeOnDelete();
            $tabel->string('judul');
            $tabel->longText('konten');
            $tabel->unsignedInteger('urutan')->default(1);
            $tabel->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('materi');
        Schema::dropIfExists('level');
        Schema::dropIfExists('modul');
    }
};
