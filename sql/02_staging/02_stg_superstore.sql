-- ============================================================
-- 02_stg_superstore.sql
-- Tujuan: Melakukan pembersihan data dan membuat staging table
--         Mencakup perbaikan error format tanggal Amerika.
-- ============================================================

USE superstore_db;

-- Menghapus tabel lama jika sudah pernah dibuat sebelumnya
DROP TABLE IF EXISTS stg_superstore;

-- Staging
CREATE TABLE stg_superstore AS
    SELECT DISTINCT
        CAST(NULLIF(order_id, '') AS CHAR(20)) AS order_id,
        CASE 
            WHEN order_date = '' THEN NULL
            ELSE STR_TO_DATE(order_date, '%m/%d/%Y')
        END AS order_date,
        CASE
            WHEN ship_date = '' THEN NULL
            ELSE STR_TO_DATE(ship_date, '%m/%d/%Y')
        END AS ship_date,
        CAST(NULLIF(ship_mode, '') AS CHAR(20)) AS ship_mode,
        CAST(NULLIF(customer_id, '') AS CHAR(10)) AS customer_id,
        CAST(NULLIF(customer_name, '') AS CHAR(50)) AS customer_name,
        CAST(NULLIF(segment, '') AS CHAR(25)) AS segment,
        CAST(NULLIF(country, '') AS CHAR(20)) AS country,
        CAST(NULLIF(state, '') AS CHAR(25)) AS state,
        CAST(NULLIF(region, '') AS CHAR(10)) AS region,
        CAST(NULLIF(product_id, '') AS CHAR(20)) AS product_id,
        CAST(NULLIF(category, '') AS CHAR(20)) AS category,
        CAST(NULLIF(sub_category, '') AS CHAR(20)) AS sub_category,
        CAST(NULLIF(product_name, '') AS CHAR(255)) AS product_name,
        CAST(NULLIF(sales, '') AS FLOAT) AS sales,
        CAST(NULLIF(quantity, '') AS SIGNED) AS quantity,
        CAST(NULLIF(discount, '') AS FLOAT) AS discount,
        CAST(NULLIF(profit, '') AS FLOAT) AS profit
    FROM superstore
;

-- Mengecek baris duplikat di data asli (row_id dikecualikan)
   -- Hasil: 1 pasang baris identik, dihapus lewat DISTINCT (9.994 baris raw -> 9.993 baris staging)
SELECT order_id, order_date, ship_date, ship_mode, customer_id, customer_name,
       segment, country, city, state, postal_code, region, product_id,
       category, sub_category, product_name, sales, quantity, discount, profit,
       COUNT(*) AS total_row,
       GROUP_CONCAT(row_id) AS row_ids
FROM superstore
GROUP BY order_id, order_date, ship_date, ship_mode, customer_id, customer_name,
         segment, country, city, state, postal_code, region, product_id,
         category, sub_category, product_name, sales, quantity, discount, profit
HAVING COUNT(*) > 1;