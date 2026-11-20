# 🛍️ Analisis Penjualan & Profitabilitas — Superstore

Analisis ini bertujuan untuk mengidentifikasi di mana kerugian terjadi pada data transaksi retail Superstore periode 2014–2017, termasuk pada tingkat diskon berapa kerugian mulai muncul. Analisis dilakukan secara deskriptif menggunakan MySQL (staging dan mart), Python untuk EDA dan visualisasi, serta Tableau untuk dashboard.

---

## 📌 Business Questions
1. Segmen pelanggan apa yang memberikan kontribusi profit paling tinggi?
2. Kategori dan sub kategori apa saja yang paling banyak menghasilkan kerugian (profit minus) akibat strategi pemberian diskon?
3. Apakah wilayah geografis dengan jumlah penjualan tertinggi selalu berbanding lurus dengan profit yang tinggi?
4. Berapa batas persentase diskon maksimal (threshold) yang masih aman diberikan tanpa mengorbankan profitabilitas (kerugian)?
5. Apakah metode pengiriman tertentu memiliki pengaruh terhadap tingkat profitabilitas?

---

## 🔍 Key Findings
- Segmen **Consumer** memberikan profit tertinggi (**134,119.21**), sedangkan profit margin antar segmen tipis (12%-14%).
- Kerugian terbesar terkonsentrasi pada sub kategori tertentu dengan diskon tinggi (misalnya **Binders** pada diskon 80% sebesar **-21,909.4**), bukan pada kategori secara keseluruhan: **Office Supplies** tetap menghasilkan total profit positif (**122,490.8**).
- **West** dan **East** sejalan antara sales dan profit, sedangkan urutan **Central** dan **South** silang: sales Central lebih tinggi, tetapi profitnya lebih rendah.
- Diskon **20%** merupakan diskon tertinggi yang masih aman (rata-rata profit **24.7**). Mulai diskon **30%** rata-rata profit menjadi negatif (**-45.83**) dengan **92%** baris data merugi.
- Metode pengiriman tidak menunjukkan perbedaan profitabilitas yang berarti (profit margin **12%-14%**).

---

## 🛠️ Tools
**Database & SQL:**
* MySQL (Data Ingestion, Staging, Mart, & Analysis)

**Python (Jupyter Notebook):**
* `pandas` & `numpy`: Data profiling & manipulation
* `sqlalchemy` & `pymysql`: Database connection
* `python-dotenv`: Environment variable management
* `matplotlib` & `seaborn`: Data visualization

**Visualization:**
* Tableau (Interactive Dashboard)

---

## 📁 Struktur Folder

```
superstore_analysis/
│
├── data/
│   └── raw/
│       └── superstore.csv                  ← CSV asli dari dataset Superstore
│   └── processed/
│   │   ├── bq1_customer_segment.csv
│   │   ├── bq2_category_loss.csv
│   │   ├── bq3_region_performance.csv
│   │   ├── bq4_discount_threshold.csv
│   |    └── bq5_ship_mode_profit.csv                  
│
├── docs/
│   ├── business_report.md                  ← Laporan bisnis lengkap
│   └── data_dictionary.md                  ← Dokumentasi tabel dan kolom
│
├── notebooks/
│   ├── 01_eda.ipynb                        ← Exploratory Data Analysis
│   └── 02_visualization.ipynb              ← Visualisasi dan insight tiap business question
│
├── sql/
│   ├── 01_setup/
│   │   ├── 00_database_setup.sql           ← Setup struktur database
│   │   └── 01_load_raw_data.sql            ← Load CSV ke MySQL
│   ├── 02_staging/
│   │   └── 02_stg_superstore.sql           ← Pembersihan data (staging)
│   └── 03_analysis/
│       ├── 03_BQ1_customer_segment.sql
│       ├── 04_BQ2_category_loss.sql
│       ├── 05_BQ3_region_performance.sql
│       ├── 06_BQ4_discount_threshold.sql
│       └── 07_BQ5_ship_mode_profit.sql
│
├── requirements.txt
├── .env                                    ← Credentials (tidak di-commit)
├── .gitignore
└── README.md
```

---

## ⚙️ Cara Menjalankan Project
1. Clone repository ini
2. Install dependencies:
```bash
pip install -r requirements.txt
```
3. Buat file `.env` di root folder dan isi credentials MySQL:
    ```
    DB_HOST=localhost
    DB_USER=root
    DB_PASSWORD=your_password
    DB_PORT=3306
    DB_NAME=superstore_db
    ```
4. Sesuaikan lokasi file CSV pada `sql/01_setup/01_load_raw_data.sql` (perintah `LOAD DATA INFILE`) dengan lokasi di komputer kamu
5. Jalankan SQL files secara berurutan mulai dari `sql/01_setup/`
6. Buka notebooks untuk visualisasi

---

## 📄 Dokumentasi
- [Business Report](docs/business_report.md)
- [Data Dictionary](docs/data_dictionary.md)
- Tableau Dashboard: _segera hadir_

---

## 📊 Dataset
[Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
