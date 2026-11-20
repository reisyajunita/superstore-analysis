# Data Dictionary - Superstore Dataset

## 1. Overview

- **Sumber Data:** [Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Jenis Data:** Data transaksi retail
- **Entitas Utama:** Customer, Order, Product, Sales, Profit
- **Rentang Waktu:** Januari 2014 - Desember 2017
- **Grain Analisis Utama:** Tingkat item produk per pesanan. Satu baris data mewakili satu jenis produk yang dibeli dalam satu transaksi.

## 2. Raw Tables

Tabel `superstore` hasil import langsung dari `superstore.csv`. Semua kolom bertipe `TEXT` karena belum dilakukan pembersihan data. Tanggal masih berformat Amerika (MM/DD/YYYY).

| Nama Kolom | Tipe Data | Deskripsi |
|-----------|----------|-----------|
| row_id | TEXT | Nomor urut baris data |
| order_id | TEXT | ID pesanan unik untuk setiap struk/transaksi pesanan |
| order_date | TEXT | Tanggal pemesanan produk |
| ship_date | TEXT | Tanggal pengiriman produk |
| ship_mode | TEXT | Metode pengiriman yang ditentukan oleh pelanggan |
| customer_id | TEXT | ID unik untuk mengidentifikasi setiap pelanggan |
| customer_name | TEXT | Nama pelanggan |
| segment | TEXT | Segmen di mana pelanggan tergabung |
| country | TEXT | Negara tempat tinggal pelanggan |
| city | TEXT | Kota tempat tinggal pelanggan |
| state | TEXT | Provinsi tempat tinggal pelanggan |
| postal_code | TEXT | Kode pos setiap pelanggan |
| region | TEXT | Wilayah di mana pelanggan tergabung |
| product_id | TEXT | ID unik produk |
| category | TEXT | Kategori produk yang dipesan |
| sub_category | TEXT | Sub kategori produk yang dipesan |
| product_name | TEXT | Nama Produk |
| sales | TEXT | Jumlah pendapatan/omset |
| quantity | TEXT | Jumlah produk |
| discount | TEXT | Diskon yang diberikan |
| profit | TEXT | Laba/Rugi yang terjadi |

## 3. Staging Tables

Tabel `stg_superstore` hasil pembersihan data dari tabel `superstore`.
Tabel ini berisi kolom-kolom yang digunakan dalam analisis.

Staging berisi 9.993 baris dari 9.994 baris data asli (1 baris duplikat dihapus lewat `DISTINCT`). Kolom `row_id`, `city`, dan `postal_code` tidak dibawa karena tidak digunakan dalam analisis.

| Nama Kolom | Tipe Data | Deskripsi |
|-----------|----------|-----------|
| order_id | VARCHAR | ID pesanan unik untuk setiap struk/transaksi pesanan |
| order_date | DATE | Tanggal pemesanan produk |
| ship_date | DATE | Tanggal pengiriman produk |
| ship_mode | VARCHAR | Metode pengiriman yang ditentukan oleh pelanggan |
| customer_id | VARCHAR | ID unik untuk mengidentifikasi setiap pelanggan |
| customer_name | VARCHAR | Nama pelanggan |
| segment | VARCHAR | Segmen di mana pelanggan tergabung |
| country | VARCHAR | Negara tempat tinggal pelanggan |
| state | VARCHAR | Provinsi tempat tinggal pelanggan |
| region | VARCHAR | Wilayah di mana pelanggan tergabung |
| product_id | VARCHAR | ID unik produk |
| category | VARCHAR | Kategori produk yang dipesan |
| sub_category | VARCHAR | Sub kategori produk yang dipesan |
| product_name | VARCHAR | Nama Produk |
| sales | FLOAT | Jumlah pendapatan/omset |
| quantity | INT | Jumlah produk |
| discount | FLOAT | Diskon yang diberikan |
| profit | FLOAT | Laba/Rugi yang terjadi |
