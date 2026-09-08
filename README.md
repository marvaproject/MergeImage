<div align="center">

<img src="AppIcon.iconset/icon_256x256@2x.png" width="120" height="120" alt="Merge Image Logo" />

# Merge Image for macOS

**Aplikasi native macOS yang super ringan, cepat, dan 100% offline untuk menggabungkan gambar.**  
Dibuat dengan Swift & SwiftUI murni tanpa framework pihak ketiga yang memberatkan.

<p align="center">
  <a href="https://github.com/marvaproject/MergeImage/releases/latest/download/MergeImage-v1.0.0-macOS.zip">
    <img src="https://img.shields.io/badge/Download-Merge%20Image%20v1.0.0%20(macOS)-blue?style=for-the-badge&logo=apple&logoColor=white" alt="Download macOS App" />
  </a>
</p>

[![Release](https://img.shields.io/github/v/release/marvaproject/MergeImage?color=blue&label=Version)](https://github.com/marvaproject/MergeImage/releases/latest)
[![macOS](https://img.shields.io/badge/Platform-macOS%2012.0%2B-lightgrey?logo=apple)](https://apple.com)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange?logo=swift)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Offline](https://img.shields.io/badge/Privacy-100%25%20Offline-success)](https://github.com)
[![Size](https://img.shields.io/badge/Size-~700%20KB-brightgreen)](https://github.com)

</div>

---

## 📥 Download Aplikasi (Untuk Pengguna Awam)

Tidak perlu paham koding untuk menggunakan aplikasi ini. Cukup klik tombol download di bawah:

<div align="center">

[![Download for macOS](https://img.shields.io/badge/⬇️%20DOWNLOAD%20APLIKASI-MERGE%20IMAGE%20FOR%20MACOS-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/marvaproject/MergeImage/releases/latest/download/MergeImage-v1.0.0-macOS.zip)

*(Kompatibel dengan macOS Monterey 12.0 atau versi yang lebih baru)*

</div>

### 🚀 Cara Install & Pakai:
1. Klik tombol **Download** di atas (akan mengunduh file `.zip`).
2. Double-click file zip yang sudah terunduh untuk mengekstrak **`Merge Image.app`**.
3. Pindahkan **`Merge Image.app`** ke folder **Applications** Mac Anda.
4. Buka aplikasi dan nikmati pengalaman menggabungkan gambar secara instan!

---

## 🌟 Fitur Utama

- 📐 **3 Mode Tata Letak (Layouts)**:
  - **Horizontal**: Menggabungkan gambar berjejer ke samping secara proporsional.
  - **Vertikal**: Menggabungkan gambar bertingkat dari atas ke bawah.
  - **Grid (Kisi)**: Mengatur gambar dalam matriks kisi dengan pilihan 1 hingga 10 kolom.

- 🎨 **Kustomisasi Border & Sudut Lengkung (Rounded)**:
  - Pilihan gaya border: `Semua (Luar & Tengah)`, `Hanya Tengah`, atau `Tanpa Border`.
  - Slider ketebalan border (default `0 px`, fleksibel hingga `100 px`).
  - Color Picker bawaan macOS (default hitam `#000000`).
  - Slider sudut melengkung / corner radius (default `0 px`, hingga `100 px`).

- 🔄 **Drag & Drop Interaktif**:
  - Seret dan lepas gambar langsung dari Finder atau klik tombol **Pilih / Lampirkan Gambar**.
  - Ubah susunan urutan gambar secara instan dengan menyeret baris gambar (**Drag & Drop Reordering**) dengan animasi spring physics Apple yang sangat mulus.

- ⚡ **Super Ringan & Bebas Lag (Dual-Pipeline Rendering)**:
  - **Live Preview Cepat (60 FPS)**: Slider border dan radius bergerak lancar tanpa membuat kipas/CPU Mac panas meski memuat banyak foto beresolusi tinggi.
  - **Ekspor Resolusi Penuh (100% Native)**: Kualitas asli foto tetap tajam sempurna tanpa kompresi yang merusak detail.

- 💾 **Simpan Otomatis ke Downloads**:
  - Tombol **Simpan ke Downloads** langsung mengekspor gambar ke folder `~/Downloads/` dengan format nama rapi `MergeImage_YYYYMMDD_HHmmss.png`.
  - Tombol cepat **Buka di Finder** untuk langsung melihat file hasil ekspor.

- 🛡️ **100% Offline & Privat**:
  - Semua proses rendering CoreGraphics dilakukan langsung di memori lokal komputer Anda. Tidak ada data yang diunggah ke cloud atau internet.

---

## 🛠️ Build dari Source Code (Untuk Developer)

```bash
git clone https://github.com/marvaproject/MergeImage.git
cd MergeImage
./build.sh
```
Aplikasi `Merge Image.app` akan langsung otomatis dibuat di folder proyek.

---

## 📄 Lisensi
Didistribusikan di bawah Lisensi [MIT](LICENSE). Bebas digunakan untuk keperluan pribadi maupun komersial.
