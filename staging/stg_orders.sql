SELECT
  Date as order_date,
  date_add(date, interval 1 month) as order_delivery_date,
  batchsize as batch_size,
  NumBatches as num_batches,
  MaterialNumber as material_number
FROM
  `maggies-sandbox.novo_case.orders`
