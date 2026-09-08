<div align="center">

<img src="AppIcon.iconset/icon_256x256@2x.png" width="128" height="128" alt="Merge Image Logo" />

# Merge Image for macOS

**Aplikasi native macOS yang super ringan, cepat, dan 100% offline untuk menggabungkan gambar.**  
Dibuat dengan Swift & SwiftUI murni tanpa framework pihak ketiga yang memberatkan.

[![macOS](https://img.shields.io/badge/Platform-macOS%2012.0%2B-blue?logo=apple)](https://apple.com)
[![Swift](https://img.shields.io/badge/Language-Swift%205.7-orange?logo=swift)](https://swift.org)
[![Offline](https://img.shields.io/badge/Security-100%25%20Offline-success)](https://github.com)
[![Size](https://img.shields.io/badge/App%20Size-~700%20KB-brightgreen)](https://github.com)

</div>

---

## 📸 Fitur Utama

- 📐 **3 Mode Tata Letak (Layouts)**:
  - **Horizontal**: Menggabungkan gambar berjejer ke samping secara proporsional.
  - **Vertikal**: Menggabungkan gambar bertingkat dari atas ke bawah.
  - **Grid (Kisi)**: Mengatur gambar dalam matriks kisi dengan jumlah kolom yang dapat disesuaikan (1 - 10 kolom).

- 🎨 **Kustomisasi Border & Sudut Lengkung (Rounded)**:
  - Pilihan gaya border: `Semua (Luar & Tengah)`, `Hanya Tengah`, atau `Tanpa Border`.
  - Slider ketebalan border (default `0 px`, fleksibel hingga `100 px`).
  - Color Picker bawaan macOS (default hitam `#000000`).
  - Slider sudut melengkung / corner radius (default `0 px`, hingga `100 px`).

- 🔄 **Drag & Drop Interaktif**:
  - Seret dan lepas file langsung dari Finder atau gunakan tombol **Pilih / Lampirkan Gambar**.
  - Ubah urutan gambar secara instan dengan menyeret baris gambar (**Drag & Drop Reordering**) dilengkapi animasi transisi halus.

- ⚡ **Super Ringan & Anti-Lag (Dual-Pipeline Rendering)**:
  - **Live Preview Cepat (60 FPS)**: Render kanvas pratinjau yang dioptimalkan sehingga slider border dan radius bergerak sehalus mentega meski memuat foto resolusi tinggi.
  - **Ekspor Resolusi Penuh (100% Native)**: Kualitas gambar asli tetap utuh tanpa kompresi yang merusak detail.

- 💾 **Simpan Otomatis ke Downloads**:
  - Tombol **Simpan ke Downloads** langsung mengekspor hasil ke `~/Downloads/` dengan nama berformat `MergeImage_YYYYMMDD_HHmmss.png`.
  - Tombol cepat **Buka di Finder** untuk langsung melihat file yang disimpan.
  - Tombol **Simpan Sebagai...** (Save As) untuk fleksibilitas folder atau format (PNG/JPEG).

- 🛡️ **100% Offline & Aman**:
  - Semua pemrosesan CoreGraphics dilakukan langsung di memori lokal komputer Anda. Tidak ada data yang dikirim ke server mana pun.

---

## 📥 Unduh & Instalasi

1. Download arsip zip rilis terbaru: **`MergeImage-v1.0.0-macOS.zip`**.
2. Ekstrak file zip tersebut.
3. Pindahkan **`Merge Image.app`** ke folder `/Applications` Mac Anda.
4. Buka aplikasi dan mulai gabungkan gambar!

---

## 🛠️ Build Sendiri dari Source Code

### Prasyarat:
- macOS 12.0 (Monterey) atau yang lebih baru
- Command Line Tools / Xcode (`swiftc`)

### Langkah Kompilasi:
```bash
git clone https://github.com/<username>/<repo-name>.git
cd "merge image"
./build.sh
```

Aplikasi `Merge Image.app` akan langsung ter-generate di folder proyek.

---

## 📄 Lisensi
Didistribusikan di bawah Lisensi MIT. Bebas digunakan untuk keperluan pribadi maupun komersial.
