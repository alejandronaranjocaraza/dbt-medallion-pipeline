select
  id,
  create_date,
  write_date,
  company_id,
  product_id,
  price_unit,
  qty,
  price_subtotal,
  order_id,
  refunded_orderline_id
from {{ source('odoo','pos_order_line') }}
