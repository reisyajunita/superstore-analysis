-- ============================================================
-- 06_BQ4_discount_threshold.sql
-- BQ4   : Berapa batas persentase diskon maksimal (threshold) 
--         yang masih menghasilkan profit positif berdasarkan data?
-- Tujuan: Melihat batas aman pemberian diskon tanpa 
--         mengorbankan kerugian.
-- ============================================================

USE superstore_db;

-- Untuk menghapus table jika sudah pernah dibuat
DROP TABLE IF EXISTS mart_disc_threshold;

CREATE TABLE mart_disc_threshold AS 
SELECT
    discount,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(*) AS total_rows,
    SUM(CASE
        WHEN profit < 0 THEN 1
        ELSE 0
    END) loss_row_count,
    ROUND((SUM(CASE
        WHEN profit < 0 THEN 1
        ELSE 0
    END)/ COUNT(*)) * 100, 2) AS loss_row_percentage
FROM stg_superstore
GROUP BY discount
ORDER BY discount ASC;