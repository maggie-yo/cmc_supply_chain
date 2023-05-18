SELECT
-- orders
  o.order_date,
  -- o.order_delivery_date,
  o.batch_size,
  o.num_batches,
  o.material_number,

 -- suppliers
  s.supplier_capacity,
  s.supplier_batch_size,

  -- materials
  m.measure_unit,
  m.supplier,
  m.type,


FROM
  `maggies-sandbox.novo_case.stg_orders` as o
left join 
  `maggies-sandbox.novo_case.stg_materials` as m
  on o.material_number=m.material_number

left join
  `maggies-sandbox.novo_case.stg_suppliers` as s
  on m.supplier=s.supplier

where
-- to find orders where the batch sizes exceed the maximum capacity of produced batches from a supplier
o.batch_size > s.supplier_batch_size
