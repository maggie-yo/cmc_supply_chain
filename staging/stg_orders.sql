SELECT
type,
supplier,
MaterialNumber as material_number,
case
  when supplier = "INJ001" then "cartridge"
  when supplier in ("INJ002", "INJ003") then "pens"
  when supplier = "OR001" then "tablets"
  when supplier = "OR002" then "duma"
  else "unknown"
  end as measure_unit,
platform,
MaterialResponsible as material_responsible
FROM
  `maggies-sandbox.novo_case.materials`
