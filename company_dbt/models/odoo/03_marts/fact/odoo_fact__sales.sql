with source_pol as (
select * from {{ ref('odoo_int__pos_order_line') }}
where is_sale = true
),
source_pp as (
select * from {{ ref('odoo_int__product') }}
),
final as (
select
  pol.id as order_line_id,
  pol.product_id as product_key,
  cast(strftime(pol.create_date_local,'%Y%m%d') as int) as create_date_key,
  pp.com_id as company_key,
  pp.bun_id as bu_key,
  pp.cat_id as category_key,
  pp.doc_id as doctor_key,
  pol.partner_id as patient_key,
  pol.order_id as order_id, -- degenerate dim
  pol.company_id as company_id, -- degenerate dim
  pol.price_unit,
  pol.price_subtotal,
  pol.qty
from source_pol pol
left join source_pp pp on pol.product_id = pp.id
)
select
  order_line_id,
  product_key,
  create_date_key,
  company_key,
  bu_key,
  category_key,
  doctor_key,
  order_id,
  company_id,
  price_unit,
  price_subtotal,
  qty
from final
