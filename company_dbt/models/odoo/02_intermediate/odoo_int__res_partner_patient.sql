-- Intermediate layer | After res_partner
-- 1) Filter res_partner by category_name = "patient"
-- 2) Deduplicates each patient record: takes latest
--    (Notice this is necessary because categories can be duplicated from source.)

with source as (
select
  surrogate_key,
  id,
  create_date_local,
  write_date_local,
  complete_name,
  active,
	birth_date,
	gender
from {{ ref('odoo_int__res_partner') }}
where category_name = 'patient'
),
dedup as (
select
  *,
  row_number() over (partition by id order by write_date_local desc nulls last) as dedup_id
from source
)
select
  surrogate_key,
  id,
  create_date_local,
  write_date_local,
  complete_name,
  active,
  birth_date,
  gender
from dedup where dedup_id = 1
