# Data Dictionary — Superstore Dataset

## 1. Overview

- **Sumber Data:** [Superstore Dataset — Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Jenis Data:** Data transaksi retail
- **Entitas Utama:** Customer, Order, Product, Sales, dan Profit
- **Rentang Waktu:** Januari 2014 – Desember 2017
- **Grain Analisis Utama:** Order line level. Satu baris data merepresentasikan satu baris item produk dalam suatu pesanan. Satu `order_id` dapat memiliki beberapa baris transaksi produk.

## 2. Raw Table

Tabel `superstore` merupakan hasil import langsung dari file `superstore.csv`. Seluruh kolom disimpan dengan tipe data `TEXT` sebelum dilakukan proses pembersihan dan transformasi data.

Kolom tanggal masih menggunakan format Amerika Serikat (`MM/DD/YYYY`).

| Nama Kolom | Tipe Data | Deskripsi |
|---|---|---|
| row_id | TEXT | Nomor identifikasi setiap baris data |
| order_id | TEXT | ID pesanan yang dapat digunakan untuk mengelompokkan beberapa baris item dalam satu pesanan |
| order_date | TEXT | Tanggal pemesanan produk |
| ship_date | TEXT | Tanggal pengiriman produk |
| ship_mode | TEXT | Metode pengiriman yang dipilih untuk pesanan |
| customer_id | TEXT | ID unik untuk mengidentifikasi pelanggan |
| customer_name | TEXT | Nama pelanggan |
| segment | TEXT | Segmen pelanggan |
| country | TEXT | Negara tempat transaksi dilakukan |
| city | TEXT | Kota tujuan pesanan |
| state | TEXT | Negara bagian tujuan pesanan |
| postal_code | TEXT | Kode pos tujuan pesanan |
| region | TEXT | Wilayah geografis tempat tujuan pesanan |
| product_id | TEXT | ID unik untuk mengidentifikasi produk |
| category | TEXT | Kategori produk |
| sub_category | TEXT | Subkategori produk |
| product_name | TEXT | Nama produk |
| sales | TEXT | Nilai penjualan produk |
| quantity | TEXT | Jumlah unit produk yang dipesan |
| discount | TEXT | Tingkat diskon yang diberikan |
| profit | TEXT | Nilai laba atau rugi dari transaksi produk |

## 3. Staging Table

Tabel `stg_superstore` merupakan hasil transformasi dan pembersihan data dari tabel `superstore`.

Proses staging mencakup penyesuaian tipe data, konversi format tanggal, serta penghapusan baris duplikat menggunakan `DISTINCT`.

Hasil staging terdiri dari **9,993 baris**, dibandingkan dengan 9,994 baris pada data awal. Satu baris tidak muncul pada hasil staging setelah proses `DISTINCT`.

Kolom `row_id`, `city`, dan `postal_code` tidak disertakan dalam tabel staging karena tidak digunakan dalam analisis project.

| Nama Kolom | Tipe Data | Deskripsi |
|---|---|---|
| order_id | VARCHAR | ID pesanan yang dapat mengelompokkan beberapa baris item dalam satu pesanan |
| order_date | DATE | Tanggal pemesanan produk |
| ship_date | DATE | Tanggal pengiriman produk |
| ship_mode | VARCHAR | Metode pengiriman yang dipilih untuk pesanan |
| customer_id | VARCHAR | ID unik untuk mengidentifikasi pelanggan |
| customer_name | VARCHAR | Nama pelanggan |
| segment | VARCHAR | Segmen pelanggan |
| country | VARCHAR | Negara tempat transaksi dilakukan |
| state | VARCHAR | Negara bagian tujuan pesanan |
| region | VARCHAR | Wilayah geografis tempat tujuan pesanan |
| product_id | VARCHAR | ID unik untuk mengidentifikasi produk |
| category | VARCHAR | Kategori produk |
| sub_category | VARCHAR | Subkategori produk |
| product_name | VARCHAR | Nama produk |
| sales | FLOAT | Nilai penjualan produk |
| quantity | BIGINT | Jumlah unit produk yang dipesan |
| discount | FLOAT | Tingkat diskon yang diberikan |
| profit | FLOAT | Nilai laba atau rugi dari transaksi produk |

## 4. Data Mart Tables

Setiap business question (BQ) memiliki satu tabel mart hasil agregasi dari `stg_superstore`. Hasilnya dibaca ke notebook lewat SQLAlchemy dan diekspor ke `data/processed/` sebagai CSV untuk Tableau.

| BQ | Tabel MySQL | File CSV | Script SQL | Grain (satu baris =) | Jumlah baris |
|---|---|---|---|---|---|
| BQ1 | `mart_customer_segment` | `bq1_customer_segment.csv` | `03_BQ1_customer_segment.sql` | Satu segmen pelanggan | 3 |
| BQ2 | `mart_category_disc_loss` | `bq2_category_loss.csv` | `04_BQ2_category_loss.sql` | Satu kombinasi category, sub_category, dan discount | 57 |
| BQ3 | `mart_region_performance` | `bq3_region_performance.csv` | `05_BQ3_region_performance.sql` | Satu region | 4 |
| BQ4 | `mart_disc_threshold` | `bq4_discount_threshold.csv` | `06_BQ4_discount_threshold.sql` | Satu tingkat diskon | 12 |
| BQ5 | `mart_ship_mode_profit` | `bq5_ship_mode_profit.csv` | `07_BQ5_ship_mode_profit.sql` | Satu metode pengiriman | 4 |

### 4.1 `mart_customer_segment` (BQ1)

| Kolom | Deskripsi |
|---|---|
| segment | Segmen pelanggan |
| total_order | Jumlah pesanan unik (`order_id`) pada segmen tersebut|
| total_sales | Total penjualan |
| total_profit | Total profit |
| profit_margin | Profit margin dalam persen (11.55 berarti 11.55%) |

### 4.2 `mart_category_disc_loss` (BQ2)
Mart berisi seluruh kombinasi category, sub_category, dan discount (profit positif maupun negatif), diurutkan dari profit terkecil.

| Kolom | Deskripsi |
|---|---|
| category | Kategori produk |
| sub_category | Subkategori produk |
| discount | Tingkat diskon dalam pecahan (0.8 berarti 80%) |
| profit | Total profit kombinasi tersebut |
| profit_margin | Profit margin dalam persen |

### 4.3 `mart_region_performance` (BQ3)

| Kolom | Deskripsi |
|---|---|
| region | Wilayah geografis |
| sales | Total penjualan |
| profit | Total profit |

### 4.4 `mart_disc_threshold` (BQ4)

| Kolom | Deskripsi |
|---|---|
| discount | Tingkat diskon dalam pecahan (0.1 berarti 10%) |
| avg_profit | Rata-rata profit per baris transaksi |
| total_profit | Total profit |
| total_rows | Jumlah baris transaksi |
| loss_row_count | Jumlah baris dengan profit negatif |
| loss_row_percentage | Persentase baris rugi dalam persen (4.26 berarti 4.26%) |

### 4.5 `mart_ship_mode_profit` (BQ5)

| Kolom | Deskripsi |
|---|---|
| ship_mode | Metode pengiriman |
| total_rows | Jumlah baris transaksi |
| avg_profit | Rata-rata profit per baris transaksi |
| total_profit | Total profit |
| profit_margin | Profit margin dalam persen |

## 5. Data Transformation

| Tahap | Proses | Dampak |
|---|---|---|
| Raw ke staging | Kolom tanggal (`order_date`, `ship_date`) diubah dari format `MM/DD/YYYY` (TEXT) ke tipe `DATE` | Tanggal dapat difilter dan diurutkan |
| Raw ke staging | Kolom numerik (`sales`, `discount`, `profit` ke FLOAT dan `quantity` ke BIGINT) diubah dari TEXT | Nilai dapat dijumlahkan dan dirata-ratakan |
| Raw ke staging | Nilai kosong diubah menjadi `NULL` | Nilai kosong tidak tercampur dengan teks kosong |
| Raw ke staging | Kolom `row_id`, `city`, dan `postal_code` tidak dibawa | 21 kolom menjadi 18 kolom |
| Raw ke staging | Baris duplikat dihapus dengan `DISTINCT` | 9,994 baris menjadi 9,993 baris |
| Staging ke mart | Agregasi per business question (satu tabel `mart_` per BQ) | 5 tabel mart |
| Mart ke CSV | Notebook `02_visualization.ipynb` mengekspor mart ke `data/processed/` | 5 file CSV untuk Tableau |

## 6. Metric Definitions

| Metrik | Definisi |
|---|---|
| Total sales / total profit | Jumlah `sales` dan `profit` pada kelompok tertentu |
| Profit margin | Total profit dibagi total sales, dikali 100 |
| Rata-rata profit | Total profit dibagi jumlah baris transaksi pada kelompok yang sama |
| Total rows | Jumlah baris transaksi (order line) |
| Total order | Jumlah pesanan (BQ1 dan KPI dashboard); berbeda dari total rows karena satu pesanan dapat memiliki beberapa baris |
| Baris rugi | Baris dengan profit negatif |
| Persentase baris rugi | Baris rugi dibagi total baris pada tingkat diskon yang sama, dikali 100 |
| Profit margin keseluruhan (KPI) | Total profit seluruh data dibagi total sales seluruh data (12.47%). Bukan rata-rata profit margin antar segmen |
| Acuan diskon (BQ4) | Tingkat diskon dengan rata-rata profit dan total profit positif serta persentase baris rugi yang relatif lebih rendah dibanding tingkat diskon berikutnya yang tersedia |

Satuan: `discount` disimpan sebagai pecahan (0.2 berarti 20%), sedangkan `profit_margin` dan `loss_row_percentage` dalam persen (11.55 berarti 11.55%).

## 7. Data Quality Notes

- **Duplikat:** ditemukan satu pasang baris identik pada seluruh kolom kecuali `row_id`. Satu baris dihapus saat staging.
- **Nilai kosong:** diubah menjadi `NULL`. Hasil pengecekan jumlah nilai kosong ada di `01_eda.ipynb`.
- **Profit ekstrem:** nilai profit minus hingga -$6,599.98 dipertahankan karena merupakan bagian dari data transaksi.
- **Tingkat diskon diskrit:** data hanya memiliki 12 tingkat diskon (0%, 10%, 15%, 20%, 30%, 32%, 40%, 45%, 50%, 60%, 70%, 80%). Tidak ada data di antara 20% dan 30%.
- **Ukuran sampel tidak merata antar tingkat diskon:**

| Diskon | 0% | 10% | 15% | 20% | 30% | 32% | 40% | 45% | 50% | 60% | 70% | 80% |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Jumlah baris | 4,798 | 94 | 52 | 3,657 | 226 | 27 | 206 | 11 | 66 | 138 | 418 | 300 |

  Rata-rata profit pada tingkat dengan baris sedikit (misalnya 45% dengan 11 baris) kurang stabil dibanding tingkat dengan baris banyak.
- **Satuan hitung berbeda antar mart:** BQ1 menghitung pesanan (`total_order`), sedangkan BQ4 dan BQ5 menghitung baris transaksi (`total_rows`).
