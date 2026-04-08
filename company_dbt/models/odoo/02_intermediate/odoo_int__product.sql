-- Intermediate layer
-- 1) Joins product_product and product_template
-- 2) Transform UTC-time to local-time

with source_pp as (
select * from {{ ref('odoo_scd2__product_product') }}
where dbt_valid_to = cast('9999-12-31' as date)
),
source_pt as (
select * from {{ ref('odoo_scd2__product_template') }}
where dbt_valid_to = cast('9999-12-31' as date)
),
final as (
select
  pp.surrogate_key,
  pp.id,
  timezone('America/Mexico_City', pp.create_date::timestamptz) as create_date_local,
  timezone('America/Mexico_City', pp.write_date::timestamptz) as write_date_local,
  pp.product_tmpl_id as template_id,
  pp.active,
  pp.analytics_reference,
  pp.com_id,
  pp.bun_id,
  pp.cat_id,
  pp.doc_id,
  timezone('America/Mexico_City', pt.create_date::timestamptz) as template_create_date_local,
  timezone('America/Mexico_City', pt.write_date::timestamptz) as template_write_date_local,
  regexp_extract(
      pt.name,
      '''es_mx'':\s*''([^'']*)''',
      1
  ) as name_es,
  regexp_extract(
      pt.name,
      '''en_us'':\s*''([^'']*)''',
      1
  ) as name_en,
  pt.detailed_type as template_detailed_type,
  pt.categ_id as category_id,
  pt.default_code as template_default_code
from source_pp pp
left join source_pt pt on pp.product_tmpl_id = pt.id
)
select
  surrogate_key,
  id,
  create_date_local,
  write_date_local,
  template_id,
  active,
  analytics_reference,
  com_id,
  bun_id,
  cat_id,
  doc_id,
  template_create_date_local,
  template_write_date_local,
  name_es,
  name_en,
  template_detailed_type,
  category_id,
  template_default_code
from final

