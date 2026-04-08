with origin as (
select
  surrogate_key,
  id,
  parent_id,
  create_date,
  write_date,
  name,
  complete_name,
  packaging_reserve_method
from {{ source('odoo','product_category') }}
),
dedup as (
select
  *,
  row_number() over (partition by id order by write_date desc) as dedup_id
from origin
)
select
  surrogate_key,
  id,
  parent_id,
  create_date,
  write_date,
  name,
  complete_name,
  packaging_reserve_method
from dedup
where dedup_id = 1
