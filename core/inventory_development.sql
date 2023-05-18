SELECT
  inv.day,
  inv.material_number,
  m.measure_unit,
  m.type,
  m.platform,
  inv.acc_batch_size as acc_orders,
  da.acc_demand,
  inv.acc_batch_size-da.acc_demand AS capasity,

FROM `maggies-sandbox.novo_case.inventory` as inv

JOIN
  `maggies-sandbox.novo_case.demand_acc` as da
  ON inv.material_number=da.material_number
  AND inv.day=da.day

JOIN `maggies-sandbox.novo_case.stg_materials` as m
  on inv.material_number=m.material_number

order by inv.day
