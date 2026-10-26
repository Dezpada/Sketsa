<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('progres', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('user_id')->constrained()->cascadeOnDelete();
            $tabel->foreignId('level_id')->constrained('level')->cascadeOnDelete();
            $tabel->enum('status', ['berjalan', 'selesai'])->default('berjalan');
            $tabel->unsignedInteger('xp_diperoleh')->default(0);
            $tabel->timestamp('selesai_pada')->nullable();
            $tabel->timestamps();
            $tabel->unique(['user_id', 'level_id']);
        });

        // Mencatat setiap percobaan, bukan hanya yang berhasil, agar pengelola
        // dapat melihat tantangan mana yang paling sering gagal.
        Schema::create('percobaan', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('user_id')->constrained()->cascadeOnDelete();
            $tabel->foreignId('tantangan_id')->constrained('tantangan')->cascadeOnDelete();
            $tabel->json('jawaban')->nullable();
            $tabel->boolean('benar')->default(false);
            $tabel->text('pesan')->nullable();
            $tabel->unsignedInteger('xp_diperoleh')->default(0);
            $tabel->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('percobaan');
        Schema::dropIfExists('progres');
    }
};
