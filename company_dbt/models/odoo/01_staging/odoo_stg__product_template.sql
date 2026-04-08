with origin as (
select
  surrogate_key,
  id,
  create_date,
  write_date,
  name,
  detailed_type,
  categ_id,
  default_code
from {{ source('odoo','product_template') }}
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
  name,
  detailed_type,
  categ_id,
  default_code
from dedup where dedup_id = 1
