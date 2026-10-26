<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $tabel) {
            $tabel->enum('peran', ['pengelola', 'peserta'])->default('peserta')->after('email');
            $tabel->unsignedInteger('total_xp')->default(0)->after('peran');
            $tabel->string('avatar')->nullable()->after('total_xp');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $tabel) {
            $tabel->dropColumn(['peran', 'total_xp', 'avatar']);
        });
    }
};
