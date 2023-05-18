SELECT
  Supplier AS supplier,
  Platform as platform,
  CAPACITY as supplier_capacity,
  Batchsize as supplier_batch_size,
  Location as location,
  Country as country

FROM
  `maggies-sandbox.novo_case.suppliers`
