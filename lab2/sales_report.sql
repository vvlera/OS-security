-- Import data from  sales_report.csv in PostgreSQL
CREATE TABLE IF NOT EXISTS sales_report (
    id               SERIAL PRIMARY KEY,
    sales_count      INTEGER,
    total_sales      NUMERIC(14,2),
    average_sale     NUMERIC(14,2),
    max_sale         NUMERIC(14,2),
    max_sale_product TEXT,
    created_at       TIMESTAMP DEFAULT now()
);

INSERT INTO sales_report (sales_count, total_sales, average_sale, max_sale, max_sale_product)
VALUES (10, 373100.00, 37310.00, 184000.00, 'Laptop');

-- Альтернатива INSERT: клиентская команда psql
-- \copy sales_report(sales_count, total_sales, average_sale, max_sale, max_sale_product) FROM 'sales_report.csv' WITH (FORMAT csv, HEADER true)
