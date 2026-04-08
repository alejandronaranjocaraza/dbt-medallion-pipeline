-- Intermediate layer | After res_partner
-- 1) Filter res_partner by category_name = "doctor"
-- 2) Deduplicates each doctor record: takes latest
--    (Notice this is necessary because categories can be duplicated from source: 5 and 9 are both "doctor".)

with source as (
select
  surrogate_key,
  id,
  create_date_local,
  write_date_local,
  complete_name,
  active,
	raw_specialty,
	raw_subspecialty,
	birth_date,
	gender
from {{ ref('odoo_int__res_partner') }}
where category_name = 'doctor'
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
  raw_specialty,
  raw_subspecialty,
  birth_date,
  gender
from dedup where dedup_id = 1

