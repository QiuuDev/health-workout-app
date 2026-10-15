# Catatan salinan GitHub — Health Workout App

Snapshot kode lokal per 15 Oktober 2026. Visibilitas repository: **public**.
Ini adalah arsip implementasi/MVP, bukan pernyataan bahwa seluruh pengujian runtime atau rilis produksi sudah lulus.

## Konfigurasi dan berkas lokal
- Kredensial, environment aktif, database operasional, unggahan pengguna, IDE/cache, dan hasil build tidak disertakan.
- SQL yang disertakan hanya struktur tabel dan indeks; buat akun/data contoh sendiri setelah import.
- Konfigurasi PHP memakai environment DB_HOST, DB_NAME, DB_USER dan DB_PASS jika tersedia.
- Folder penyimpanan/upload yang dikecualikan perlu dibuat dengan izin yang sesuai saat menjalankan aplikasi.
- Source asli pada laptop tidak diubah oleh proses unggah ini.

## Firebase
Konfigurasi deployment diganti placeholder. Jalankan `flutterfire configure` menggunakan proyek Firebase milik Anda sebelum menjalankan aplikasi; file google-services.json/GoogleService-Info.plist tidak disertakan. Periksa rules Firestore dan Authentication pada proyek Anda.

## Aset visual contoh
Foto dan GIF workout lokal diganti ikon placeholder dari scaffold Flutter pada salinan public karena hak distribusi aset asli belum diverifikasi. Ganti dengan aset milik sendiri/berlisensi sesuai sebelum rilis. Semua path referensi disesuaikan agar aset placeholder dapat dimuat.
