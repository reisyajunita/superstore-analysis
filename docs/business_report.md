# Business Report - Superstore Sales Performance & Profitability Analysis

## Executive Summary
Analisis ini bertujuan untuk mengidentifikasi di mana kerugian terjadi sehingga perusahaan dapat mengambil keputusan yang sesuai dalam penetapan diskon. Hasilnya menunjukkan rata-rata profit masih positif pada diskon hingga 20% (24.7), tetapi menjadi negatif mulai diskon 30% (-45.83), dengan 92% baris data merugi. Kerugian terbesar terkonsentrasi pada sub kategori tertentu (Binders, Machines, dan Appliances) pada diskon 70%-80%, bukan pada kategori secara keseluruhan: 'Office Supplies' tetap menghasilkan total profit positif sebesar 122,490.8. Selain itu, region dengan sales lebih tinggi belum tentu menghasilkan profit lebih tinggi, dan metode pengiriman tidak menunjukkan perbedaan profitabilitas yang berarti. Perusahaan disarankan membatasi diskon pada kisaran 20% dan mengevaluasi diskon tinggi pada sub kategori tertentu.

---

## 1. Business Context (Konteks Bisnis)
Sebuah perusahaan retail berskala besar (Superstore) menghadapi persaingan pasar yang semakin ketat. Untuk mempertahankan pangsa pasar dan volume penjualan, Superstore secara agresif menerapkan berbagai strategi promosi dan pemberian diskon di berbagai wilayah dan kategori produk. Sebagai jaringan retail raksasa, menjaga keseimbangan antara volume penjualan (`sales`) dan margin keuntungan (`profit`) adalah kunci utama keberlanjutan bisnis. Namun, indikasi awal menunjukkan bahwa strategi pemasaran dan penetapan harga saat ini belum sepenuhnya optimal dan memerlukan evaluasi menyeluruh.

---

## 2. Business Problem (Masalah Bisnis)
Meskipun perusahaan berhasil mencetak angka penjualan (*sales*) yang terus berjalan, ditemukan anomali yang mengkhawatirkan pada struktur profitabilitas. Terdapat transaksi-transaksi spesifik yang menghasilkan kerugian (*profit* minus) secara ekstrem, di mana perusahaan harus menanggung kerugian hingga lebih dari $6,000 pada satu transaksi.

Indikasi awal dari diagnosa data menunjukkan bahwa kerugian ini tampak muncul pada tingkat diskon yang sangat tinggi (mencapai 80%). Masalah utamanya adalah: **Perusahaan saat ini tidak memiliki visibilitas yang jelas mengenai program diskon mana, pada kategori produk apa, dan di wilayah mana yang sebenarnya "membakar uang" tanpa memberikan *Return on Investment* (ROI) yang positif.** Oleh karena itu, diperlukan analisis mendalam untuk mengidentifikasi di mana kebocoran profit ini terjadi agar perusahaan dapat merumuskan strategi penargetan pelanggan dan penetapan diskon yang lebih efektif dan efisien.

---

## 3. Business Objective (Tujuan Bisnis)
Tujuan dari analisis ini adalah mengidentifikasi di mana dan pada tingkat diskon berapa kerugian terjadi sehingga perusahaan dapat mengambil keputusan dalam merumuskan penargetan pelanggan dan penetapan diskon yang efektif dan efisien.

---

## 4. Business Questions (Pertanyaan Bisnis)
1. Segmen pelanggan apa yang memberikan kontribusi profit paling tinggi?
2. Kategori dan sub kategori apa saja yang paling banyak menghasilkan kerugian (profit minus) akibat strategi pemberian diskon?
3. Apakah wilayah geografis dengan jumlah penjualan tertinggi selalu berbanding lurus dengan profit yang tinggi?
4. Berapa batas persentase diskon maksimal (threshold) yang masih aman diberikan tanpa mengorbankan profitabilitas (kerugian)?
5. Apakah metode pengiriman tertentu memiliki pengaruh terhadap tingkat profitabilitas?

---

## 5. Dataset Overview
- **Sumber Data:** [Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Deskripsi:** Dataset ini berisi data transaksi penjualan retail Superstore, mencakup informasi pelanggan, produk, wilayah, metode pengiriman, diskon, penjualan, dan profit dengan rentang waktu dari **Januari 2014 sampai Desember 2017**.
- **Jumlah Data:** 9,994 baris data asli, menjadi 9,993 baris pada tahap staging setelah 1 baris duplikat dihapus.
- **Grain Analisis Utama:** Tingkat item produk per pesanan. Satu baris data mewakili satu jenis produk yang dibeli dalam satu transaksi.

---

## 6. Methodology
- **Jenis Analisis:** Analisis deskriptif yang digunakan untuk membandingkan performa penjualan dan profit antar kelompok (segmen, kategori, region, diskon, metode pengiriman) berdasarkan data historis, tanpa prediksi dan tanpa membuktikan sebab-akibat.
- **Tools:**
  - **Database & SQL:** MySQL (Staging, Mart, & Analysis)
  - **Python (Jupyter Notebook):**
    - `pandas` & `numpy`: Data profiling & manipulation
    - `sqlalchemy` & `pymysql`: Database connection
    - `python-dotenv`: Environment variable management
    - `matplotlib` & `seaborn`: Data visualization
  - **Visualization:** Tableau (Interactive Dashboard)
- **Pendekatan Pengolahan Data:**
  - **Raw:** Data mentah dari `superstore.csv` diimpor ke MySQL dengan `LOAD DATA INFILE` ke tabel `superstore`, semua kolom bertipe `TEXT`, tanpa perubahan.
  - **Staging:** Data dibersihkan dan dipilih kolom yang relevan ke tabel `stg_superstore` (tipe data diperbaiki, format tanggal diubah, dan baris duplikat dihapus).
  - **Mart:** Hasil agregasi tiap business question disimpan sebagai tabel `mart_` (satu tabel per BQ), sehingga notebook dan dashboard membaca angka dari sumber yang sama.
  - **Visualisasi:** Tabel mart dibaca ke notebook lewat SQLAlchemy untuk dibuat grafik, dan hasil akhirnya divisualisasikan di dashboard Tableau.
- **Pembersihan Data:**
  - Format tanggal Amerika (MM/DD/YYYY) diubah ke tipe `DATE`, dan kolom numerik diubah dari teks ke angka.
  - Nilai kosong diubah menjadi `NULL`.
  - Ditemukan 1 pasang baris identik di semua kolom kecuali `row_id`, lalu dihapus saat staging (9,994 menjadi 9,993 baris). `row_id` dikecualikan saat mengecek karena nomor urut selalu unik.
  - Kolom `row_id`, `city`, dan `postal_code` tidak dibawa ke staging karena tidak digunakan dalam analisis.
  - Nilai profit minus ekstrem (hingga -$6,599.98) dipertahankan karena wajar pada diskon tinggi.
- **Definisi Metrik:**
  - **Profit margin:** total profit dibagi total sales, dikali 100.
  - **Persentase baris rugi:** jumlah baris dengan profit negatif dibagi total baris pada tingkat diskon yang sama, dikali 100.
  - **Diskon aman (BQ4):** tingkat diskon dengan rata-rata profit dan total profit positif, serta persentase baris rugi yang jauh lebih rendah dibanding diskon di atasnya.

---

## 7. Key Findings

### BQ1: Segmen Pelanggan dengan Profit Tertinggi
**Fakta:** Segmen Consumer memberikan profit tertinggi sebesar 134,119.21. Home Office memiliki profit margin tertinggi (14%), tetapi selisihnya tipis dibanding segmen lain (12%-14%).

**Insight:** Karena margin antar segmen hampir sama, besarnya profit lebih sejalan dengan jumlah pesanan: Consumer punya 2,586 pesanan, jauh lebih banyak dibanding Corporate (1,514) dan Home Office (909).

---

### BQ2: 5 Sub Kategori Teratas yang Mengalami Kerugian Akibat Diskon
**Fakta:** Profit minus terparah ada pada kategori 'Office Supplies' pada sub kategori 'Binders' sebesar -21,909.4 pada diskon 80%. Kerugian profit margin tertinggi ada pada kategori 'Office Supplies' pada sub kategori 'Appliances' sebesar -255% dari total penjualannya pada diskon 80% dengan profit sebesar -8,629.64.

**Insight:** Kerugian terkonsentrasi pada sub kategori tertentu yang diberi diskon tinggi (terutama 70%-80%), bukan pada kategori secara keseluruhan. Hal ini terlihat dari kategori 'Office Supplies' yang secara total tetap menghasilkan profit positif sebesar 122,490.8.

---

### BQ3: Hubungan Penjualan dengan Profit per Wilayah
**Fakta:** West memiliki sales tertinggi (725,457.82) dan profit tertinggi (108,418), diikuti East (678,499.87 dan 91,535). Urutan Central dan South silang: Central memiliki sales lebih tinggi (501,239.89 vs 391,721.91), tetapi profit lebih rendah (39,706 vs 46,749).

**Insight:** Besarnya penjualan saja tidak cukup untuk menilai performa suatu region, karena region dengan sales lebih tinggi belum tentu menghasilkan profit lebih tinggi.

---

### BQ4: Batas Diskon Maksimal yang Aman
**Fakta:** Diskon 20% merupakan diskon tertinggi yang masih aman karena memenuhi tiga kriteria: rata-rata profit positif sebesar 24.7, total profit sebesar 90,337.31, dan persentase baris rugi 14% (502 dari 3,657 baris) yang lebih rendah dibanding diskon di atasnya. Sebaliknya, diskon 30% memiliki rata-rata profit -45.83 dan persentase baris rugi 92%. Batas persisnya belum dapat ditentukan karena tidak ada data di antara 20% dan 30%.

**Insight:** Perubahan persentase baris rugi yang tajam setelah diskon 20% menunjukkan kerugian mulai mendominasi pemberian diskon di atas batas tersebut.

---

### BQ5: Pengaruh Metode Pengiriman terhadap Profitabilitas
**Fakta:** Profit margin dan rata-rata profit antar metode pengiriman memiliki selisih yang tipis, dengan rentang 12%-14% untuk profit margin dan 27.5-31.84 untuk rata-rata profit. Total profit 'Standard Class' paling tinggi (164,100.85) karena jumlah barisnya paling banyak (5,967), bukan karena lebih menguntungkan.

**Insight:** Tidak ditemukan perbedaan berarti antar metode pengiriman karena selisih profitabilitasnya kecil.

---

## 8. Recommendation
1. **Batasi diskon pada kisaran 20%:** Diskon di atas 20% perlu dievaluasi ulang karena mulai diskon 30% rata-rata profit negatif dan sebagian besar transaksi merugi. (Dasar: BQ4)
2. **Evaluasi diskon tinggi pada sub kategori tertentu:** Fokuskan evaluasi pada diskon 70%-80% di sub kategori dengan kerugian terbesar, yaitu Binders, Machines, dan Appliances, bukan pada seluruh kategori. (Dasar: BQ2)
3. **Metode pengiriman tidak perlu diprioritaskan untuk meningkatkan profit:** Margin dan rata-rata profit antar metode hampir sama. (Dasar: BQ5)
