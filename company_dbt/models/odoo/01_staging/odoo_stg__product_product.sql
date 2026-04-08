with origin as (
select
  surrogate_key,
  id,
  create_date,
  write_date,
  product_tmpl_id,
  active,
  referencia_analisis as analytics_reference,
  (string_split(referencia_analisis,'-'))[1] as com_id,
  (string_split(referencia_analisis,'-'))[2] as bun_id,
  (string_split(referencia_analisis,'-'))[3] as cat_id,
  try_cast((string_split(referencia_analisis,'-'))[4] as int) as doc_id
from {{ source('odoo','product_product') }}
),
dedup AS (
select
  *,
  row_number() over (partition by id order by write_date desc) as dedup_id
from origin
)
select
  surrogate_key,
  id,
  create_date,
  write_date,
  product_tmpl_id,
  active,
  analytics_reference,
  com_id,
  bun_id,
  cat_id,
  doc_id
from dedup where dedup_id = 1
