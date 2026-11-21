-- ============================================================
-- 07_BQ5_ship_mode_profit.sql
-- BQ5   : Apakah terdapat perbedaan profitabilitas antar
--         metode pengiriman?
-- Tujuan: Mengetahui hubungan antara metode pengiriman dengan
--         profit yang didapat
-- ============================================================

USE superstore_db;

-- Untuk menghapus table jika sudah pernah dibuat
DROP TABLE IF EXISTS mart_ship_mode_profit;

CREATE TABLE mart_ship_mode_profit AS
SELECT ship_mode,
    COUNT(*) AS total_rows,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin
FROM stg_superstore
GROUP BY ship_mode
ORDER BY total_profit DESC;