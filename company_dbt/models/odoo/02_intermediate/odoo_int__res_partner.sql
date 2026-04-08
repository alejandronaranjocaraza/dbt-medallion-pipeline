-- Intermediate layer
-- 1) Transform UTC-time to local-time
-- 2) Extracts partner age
-- 3) Joins pertner_category
--    (Notice that this expands the original res_partner model. Each partner can have multuple categories. Rowsare generated for each of these categories)

with source_rp as (
select * from {{ ref('odoo_scd2__res_partner') }}
where dbt_valid_to = '9999-12-31'
),
source_rprpcr as (
select * from {{ ref('odoo_stg__res_partner_res_partner_category_rel') }}
),
source_rpc as (
select * from {{ ref('odoo_seed__res_partner_category') }}
)
select
  rp.surrogate_key,
  rp.id,
  rprpcr.category_id as category_id,
  timezone('America/Mexico_City', rp.create_date::timestamptz) as create_date_local,
  timezone('America/Mexico_City', rp.write_date::timestamptz)  as write_date_local,
  rp.complete_name,
  rpc.name as category_name,
  rp.active,
	rp.raw_specialty,
	rp.raw_subspecialty,
	rp.birth_date,
	rp.gender
from source_rp rp
left join source_rprpcr rprpcr on rp.id =  rprpcr.partner_id
left join source_rpc rpc on rprpcr.category_id = rpc.id
