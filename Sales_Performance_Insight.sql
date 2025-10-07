/*
=============================================================
Creazione tabelle ed importazione datasets da files csv
=============================================================
*/

CREATE SCHEMA gold;
SET search_path TO gold, public;

CREATE TABLE gold.dim_customers(
	customer_key int,
	customer_id int,
	customer_number varchar(50),
	first_name varchar(50),
	last_name varchar(50),
	country varchar(50),
	marital_status varchar(50),
	gender varchar(50),
	birthdate date,
	create_date date
);

CREATE TABLE gold.dim_products(
	product_key int ,
	product_id int ,
	product_number varchar(50) ,
	product_name varchar(50) ,
	category_id varchar(50) ,
	category varchar(50) ,
	subcategory varchar(50) ,
	maintenance varchar(50) ,
	cost int,
	product_line varchar(50),
	start_date date 
);

CREATE TABLE gold.fact_sales(
	order_number varchar(50),
	product_key int,
	customer_key int,
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity smallint,
	price int 
);


/*
=============================================================
Esplorazione Dimensioni
=============================================================
*/

-- Lista unica dei Paesi da cui provengono i clienti
SELECT DISTINCT 
    country 
FROM gold.dim_customers
ORDER BY country;

-- elenco di categorie, sottocategorie e prodotti unici
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products
ORDER BY category, subcategory, product_name;


/*
===============================================================================
Esplorazione Misure (Key Metrics)
===============================================================================
*/
-- Totale vendite
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Totale articoli venduti
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Prezzo medio articoli venduti
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Numero totale ordini
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Totale prodotti 
SELECT COUNT(product_name) AS total_products FROM gold.dim_products

-- Clienti totali
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Totale clienti che hanno ordinato
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Report che mostra tutte le Key metrics del Business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;


/*
===============================================================================
Magnitude Analysis
===============================================================================
*/

-- Totale clienti per Paese
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Totale clienti per genere
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Totale prodotti per categoria
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Costo medio prodotti divisi per categoria
SELECT
    category,
    AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Ricavo totale generato per categoria
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Ricavo totale generato da ogni cliente
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Distribuzione numero totale articoli venduti per Paese
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;


/*
===============================================================================
Ranking Analysis
===============================================================================
*/

-- Top 5 prodotti che generano i maggiori Ricavi
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Top 10 Clienti che hanno generato i maggiori Ricavi
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM
    gold.fact_sales f
LEFT JOIN
    gold.dim_customers c
        ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY
    total_revenue DESC
LIMIT 10; 


/*
===============================================================================
Analisi temporale
===============================================================================
Obiettivo:
- Monitorare trend, crescita e variazioni delle metriche chiave nel corso del tempo.
===============================================================================
*/

SELECT
    DATE_TRUNC('month', order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);


/*
===============================================================================
Analisi Cumulativa
===============================================================================
Obiettivo:
    - Calcolare totali progressivi (running totals) o medie mobili (moving averages) per le metriche chiave.
    - Utile per l'analisi della crescita o l'identificazione di trend a lungo termine.
*/

-- Calolo del running total delle vendite e della media mobile del prezzo medio nel tempo
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT 
        DATE_TRUNC('year', order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('year', order_date)
);


/*
===============================================================================
Analisi delle performance (anno su anno)
===============================================================================
Obiettivo:
    - Misurare la **performance** (la resa) di prodotti, clienti o regioni nel tempo.
    - Utilizzare l'analisi per il benchmarking e per identificare le entità con le prestazioni migliori.
    - Monitorare i **trend** e la crescita annuale.
===============================================================================
	
Analisi delle performance annuale dei prodotti confrontando le loro vendite
sia con la performance di vendita media del prodotto che con le vendite dell'anno precedente. */
WITH yearly_product_sales AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM
        gold.fact_sales f
    LEFT JOIN
        gold.dim_products p
            ON f.product_key = p.product_key
    WHERE
        f.order_date IS NOT NULL
    GROUP BY
        EXTRACT(YEAR FROM f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    -- Analisi Media Globale (sulle vendite del prodotto)
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    -- Analisi Anno su Anno 
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM
    yearly_product_sales
ORDER BY
    product_name,
    order_year;


/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Obbiettivo:
    - Raggruppare i dati in categorie significative per ricavare insights.
===============================================================================
*/

/*Segmenta i prodotti in fasce di costo e conta quanti prodotti rientrano in ciascun segmento.*/
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Obiettivo:
    - Confrontare la performance o le metriche tra diverse dimensioni o periodi temporali.
    - Valutare le differenze tra le categorie.
===============================================================================

*/
-- Quali categorie contribuiscono maggiormente alle vendite complessive?
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND(total_sales / SUM(total_sales) OVER () * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;