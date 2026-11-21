-- ============================================================
-- 05_BQ3_region_performance.sql
-- BQ3   : Apakah wilayah geografis dengan jumlah penjualan 
--         tertinggi selalu menghasilkan profit yang lebih tinggi?
-- Tujuan: Melihat performa penjualan dengan profit yang
--         didapat berdasarkan wilayah geografis.
-- ============================================================

USE superstore_db;

-- Untuk menghapus table jika sudah pernah dibuat
DROP TABLE IF EXISTS mart_region_performance;

-- Membuat table khusus untuk pelaporan BQ3
CREATE TABLE mart_region_performance AS
    SELECT region,
            ROUND(SUM(sales), 2) AS sales,
            ROUND(SUM(profit), 2) AS profit
    FROM stg_superstore
    GROUP BY region
    ORDER BY profit DESC;