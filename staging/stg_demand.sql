WITH demands AS (
SELECT
  Date as demand_deadline,
  Demand as demand_qqt,
  MaterialNumber as material_number
FROM
  `maggies-sandbox.novo_case.demands`

UNION ALL 

--creating DP demands
SELECT
-- since not mentioned assumming order_date=demand_date
  O.order_date,
  --an assembly order of 1 duma corresponds to a DP demand of 20 tablets
  IF(supplier='OR002', batch_size*20,batch_size) AS batch_size,
  L.material_number_dp,
FROM `maggies-sandbox.novo_case.core_orders` AS O
--some material_number are missing so I assume that is DQ issue, therefore the INNER JOIN
INNER JOIN `maggies-sandbox.novo_case.stg_link` AS L
  ON o.material_number=L.material_number_ass
WHERE type ='Assembly'

),
min_order AS (
SELECT
  material_number,
  MIN(order_delivery_date) AS min_order_delivery_date
FROM
  `maggies-sandbox.novo_case.stg_orders`
GROUP BY
  material_number
)

SELECT 
  demands.*,
FROM demands 
LEFT JOIN min_order
  USING(material_number)
-- assuming that if a demand is created before the min order delivery date it's a DQ issue
WHERE demand_deadline > min_order_delivery_date
