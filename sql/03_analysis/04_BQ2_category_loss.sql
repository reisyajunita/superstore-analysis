-- ============================================================
-- 04_BQ2_category_loss.sql
-- BQ2   : Kategori dan sub kategori apa saja yang paling 
--         banyak menghasilkan kerugian (profit minus) 
--         akibat strategi pemberian diskon?
-- Tujuan: Melihat kategori dan sub kategori mana yang
--         memberikan kerugian akibat pemberian diskon
-- ============================================================

USE superstore_db;

-- Untuk menghapus table jika sudah pernah dibuat
DROP TABLE IF EXISTS mart_category_disc_loss;

-- Membuat table khusus untuk pelaporan BQ2
CREATE TABLE mart_category_disc_loss AS
    SELECT category,
            sub_category, 
            discount, 
            ROUND(SUM(profit), 2) AS profit,
            ROUND(SUM(profit) / NULLIF(SUM(sales), 0)*100, 2) AS profit_margin
    FROM stg_superstore
    GROUP BY category, sub_category, discount
    ORDER BY profit;

-- Melihat total profit kategori Office Supplies (tidak digabungkan ke dalam tabel)
    SELECT 
        category,
        ROUND(SUM(profit), 2) AS profit
    FROM stg_superstore
    WHERE category = 'Office Supplies';