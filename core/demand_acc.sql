with base as (
SELECT 
    material_number,
    demand_deadline,
    MIN(demand_deadline) OVER (PARTITION BY material_number) AS min_start_date,
    MAX(demand_deadline) OVER (PARTITION BY material_number) AS max_end_date,
    LEAD(demand_deadline) OVER (PARTITION BY material_number ORDER BY demand_deadline) AS next_demand_deadline,
    SUM(demand_qqt) OVER (PARTITION BY material_number ORDER BY demand_deadline ASC) AS acc_demand_qqt
FROM `maggies-sandbox.novo_case.stg_demand` 
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
SUM(acc_demand_qqt) as acc_demand
FROM daterange AS D
INNER JOIN base AS B 
    ON D.day >= B.demand_deadline 
    AND (D.day < B.next_demand_deadline OR next_demand_deadline IS NULL)
    AND D.material_number = B.material_number

group by 1,2
order by day
