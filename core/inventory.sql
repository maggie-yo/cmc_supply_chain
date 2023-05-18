with base as (
SELECT 
    material_number,
    order_delivery_date,
    MIN(order_delivery_date) OVER (PARTITION BY material_number) AS min_start_date,
    MAX(order_delivery_date) OVER (PARTITION BY material_number) AS max_end_date,
    LEAD(order_delivery_date) OVER (PARTITION BY material_number ORDER BY order_delivery_date) AS next_order_delivery_date,
    batch_size,
    SUM(batch_size) OVER (PARTITION BY material_number ORDER BY order_delivery_date ASC) AS acc_batch_size
FROM `maggies-sandbox.novo_case.core_orders` 
), 
daterange AS(
SELECT DISTINCT 
    b.material_number,
    day
FROM base AS B
    CROSS JOIN UNNEST(GENERATE_DATE_ARRAY( B.min_start_date, B.max_end_date , INTERVAL 1 DAY)) AS day
)

SELECT
    D.day,
    d.material_number,
    SUM(acc_batch_size) AS acc_batch_size,
SUM(batch_size) as inventory

FROM daterange AS D
INNER JOIN base AS B 
    ON D.day >= B.order_delivery_date 
    AND (D.day < B.next_order_delivery_date OR next_order_delivery_date IS NULL)
    AND D.material_number = B.material_number


group by 1,2
order by day
