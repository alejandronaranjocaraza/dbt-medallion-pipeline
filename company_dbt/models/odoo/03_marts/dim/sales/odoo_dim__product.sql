with source_pp as (
select * from {{ ref('odoo_int__product') }}
),
source_pc as (
select * from {{ ref('odoo_int__product_category') }}
),
source_bu as (
select * from {{ ref('odoo_seed__business_unit') }}
),
source_co as (
select * from {{ ref('odoo_seed__company') }}
)
select
  pp.surrogate_key, --VERIFY THIS
  pp.id,
  pp.create_date_local,
  pp.write_date_local,
  pp.active,
  pp.analytics_reference,
  pp.com_id,
  pp.bun_id,
  pp.cat_id,
  pp.doc_id,
  co.name as company_name,
  bu.name as bu_name,
  -- ca.name as category_name,
  pp.template_create_date_local,
  pp.template_write_date_local,
  pp.name_es,
  pp.name_en,
  pp.template_detailed_type,
  pp.category_id,
  pp.template_default_code,
  pc.name as category_name,
  pc.complete_name as category_complete_name,
  pc.packaging_reserve_method as category_packaging_reserve_method
from source_pp pp
left join source_pc pc on pp.category_id = pc.id
left join source_bu bu on pp.bun_id = bu.id
left join source_co co on pp.com_id = co.id
