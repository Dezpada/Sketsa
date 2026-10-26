<?php

namespace App\Services;

use App\Models\Tantangan;

/**
 * Menilai jawaban peserta untuk ketiga bentuk tantangan.
 *
 * Kriteria penilaian tantangan koding tidak ditulis di kelas ini, melainkan
 * dibaca dari tabel tantangan_aturan yang diisi pengelola melalui formulir.
 */
class Penilai
{
    public function nilai(Tantangan $tantangan, array $jawaban): array
    {
        return match ($tantangan->jenis) {
            'pilihan_ganda' => $this->pilihanGanda($tantangan, $jawaban),
            'drag_drop' => $this->dragDrop($tantangan, $jawaban),
            default => $this->koding($tantangan, $jawaban),
        };
    }

    protected function pilihanGanda(Tantangan $tantangan, array $jawaban): array
    {
        $pilihan = $jawaban['item_id'] ?? null;

        if (! $pilihan) {
            return $this->gagal('Pilih salah satu jawaban terlebih dahulu.');
        }

        $item = $tantangan->item->firstWhere('id', (int) $pilihan);

        if ($item && $item->benar) {
            return $this->lulus();
        }

        return $this->gagal('Jawaban belum tepat. Baca lagi materinya, lalu coba sekali lagi.');
    }

    protected function dragDrop(Tantangan $tantangan, array $jawaban): array
    {
        $urutan = $jawaban['urutan'] ?? [];

        if (count($urutan) !== $tantangan->item->count()) {
            return $this->gagal('Jawaban belum lengkap. Susun seluruh langkah terlebih dahulu.');
        }

        foreach ($urutan as $posisi => $itemId) {
            $item = $tantangan->item->firstWhere('id', (int) $itemId);

            if (! $item || $item->urutan_benar !== $posisi + 1) {
                return $this->gagal('Urutannya belum tepat. Perhatikan langkah mana yang harus dijalankan lebih dahulu.');
            }
        }

        return $this->lulus();
    }

    /**
     * Menilai tantangan koding berdasarkan tabel tantangan_aturan.
     *
     * Catatan: jumlah pemanggilan fungsi dan keberadaan kanvas dilaporkan oleh
     * peramban, sehingga nilainya dapat dipalsukan oleh peserta yang memahami
     * cara kerjanya. Aturan mengandung_teks dan tidak_mengandung diperiksa
     * langsung pada kode yang dikirim, sehingga lebih sulit dimanipulasi.
     */
    protected function koding(Tantangan $tantangan, array $jawaban): array
    {
        $hasil = [
            'kode' => (string) ($jawaban['kode'] ?? ''),
            'total' => (array) ($jawaban['total'] ?? []),
            'setelah_setup' => (array) ($jawaban['setelah_setup'] ?? []),
            'ada_kanvas' => (bool) ($jawaban['ada_kanvas'] ?? false),
        ];

        foreach ($tantangan->aturan as $aturan) {
            if (! $this->cekAturan($aturan, $hasil)) {
                return $this->gagal($aturan->pesan_gagal);
            }
        }

        return $this->lulus();
    }

    protected function cekAturan($aturan, array $hasil): bool
    {
        return match ($aturan->jenis_aturan) {
            'kanvas_terbentuk' => $hasil['ada_kanvas'],
            'mengandung_teks' => str_contains($hasil['kode'], (string) $aturan->target),
            'tidak_mengandung' => ! str_contains($hasil['kode'], (string) $aturan->target),
            'jumlah_panggil' => $this->bandingkan(
                $this->hitungPanggil($hasil, (string) $aturan->target, $aturan->cakupan),
                $aturan->operator,
                (int) $aturan->nilai
            ),
            default => true,
        };
    }

    protected function hitungPanggil(array $hasil, string $target, ?string $cakupan): int
    {
        $total = (int) ($hasil['total'][$target] ?? 0);
        $setup = (int) ($hasil['setelah_setup'][$target] ?? 0);

        return match ($cakupan) {
            'setup' => $setup,
            'draw' => $total - $setup,
            default => $total,
        };
    }

    protected function bandingkan(int $angka, ?string $operator, int $nilai): bool
    {
        return match ($operator) {
            '>=' => $angka >= $nilai,
            '<=' => $angka <= $nilai,
            default => $angka === $nilai,
        };
    }

    protected function lulus(): array
    {
        return ['lulus' => true, 'pesan' => 'Tantangan selesai. Jawabanmu sudah tepat.'];
    }

    protected function gagal(string $pesan): array
    {
        return ['lulus' => false, 'pesan' => $pesan];
    }
}
