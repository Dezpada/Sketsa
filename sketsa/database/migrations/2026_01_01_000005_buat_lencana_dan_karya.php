<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('lencana', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->string('nama');
            $tabel->text('keterangan')->nullable();
            $tabel->foreignId('level_id')->nullable()->constrained('level')->nullOnDelete();
            $tabel->timestamps();
        });

        Schema::create('lencana_pengguna', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('user_id')->constrained()->cascadeOnDelete();
            $tabel->foreignId('lencana_id')->constrained('lencana')->cascadeOnDelete();
            $tabel->timestamp('diperoleh_pada')->nullable();
            $tabel->timestamps();
            $tabel->unique(['user_id', 'lencana_id']);
        });

        Schema::create('karya', function (Blueprint $tabel) {
            $tabel->id();
            $tabel->foreignId('user_id')->constrained()->cascadeOnDelete();
            $tabel->string('judul');
            $tabel->longText('kode');
            $tabel->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('karya');
        Schema::dropIfExists('lencana_pengguna');
        Schema::dropIfExists('lencana');
    }
};
