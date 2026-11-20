-- ============================================================
-- 03_BQ1_customer_segment.sql
-- BQ1   : Segmen pelanggan apa yang memberikan kontribusi 
--         profit paling tinggi? 
-- Tujuan: Melihat perbandingan profit dari berbagai segmen
--         pelanggan.
-- ============================================================

USE superstore_db;

-- Untuk menghapus table jika sudah pernah dibuat
DROP TABLE IF EXISTS mart_customer_segment;

-- Membuat table khusus untuk pelaporan BQ1
CREATE TABLE mart_customer_segment AS
    SELECT 
        segment,
        COUNT(DISTINCT order_id) AS total_order,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND((SUM(profit)/NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin
FROM stg_superstore
GROUP BY segment
ORDER BY total_profit DESC;