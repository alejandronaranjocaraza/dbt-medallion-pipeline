-- Intermediate layer
-- 1) Removes erroneuous entries
-- 2) Extracts order_state and partner_id from pos_orders
-- 3) Transform UTC-time to local-time
-- 4) Converts order state to is_sale bool

with source_pol as (
select * from {{ ref('odoo_stg__pos_order_line') }}
),
source_po as (
select * from {{ ref('odoo_int__pos_order') }}
),
erroneous_ids as (
select id from source_pol
where refunded_orderline_id is not null
union
select refunded_orderline_id from source_pol
where refunded_orderline_id is not null
),
cleaned as (
select
  pol.id,
  pol.order_id,
  pol.company_id,
  pol.product_id,
  po.partner_id as partner_id,
  timezone('America/Mexico_City', pol.create_date::timestamptz) as create_date_local,
  timezone('America/Mexico_City', pol.write_date::timestamptz) as write_date_local,
  pol.price_unit,
  pol.qty,
  pol.price_subtotal,
  po.state as order_state,
  po.is_sale
from source_pol pol
left join source_po po on pol.order_id = po.id
where pol.id not in (select id from erroneous_ids)
)
select
  id,
  order_id,
  company_id,
  product_id,
  partner_id,
  create_date_local,
  write_date_local,
  price_unit,
  qty,
  price_subtotal,
  order_state,
  is_sale
from cleaned
