-- Intermediate layer
-- 1) Transform UTC-time to local-time

select
  surrogate_key,
  id,
  parent_id,
  name,
  complete_name,
  packaging_reserve_method,
  timezone('America/Mexico_City', create_date::timestamptz) as create_date_local,
  timezone('America/Mexico_City', write_date::timestamptz)  as write_date_local
from {{ ref('odoo_scd2__product_category') }}
where dbt_valid_to = '9999-12-31'
