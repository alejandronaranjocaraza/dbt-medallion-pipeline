-- Intermediate layer
-- 1) Transform UTC-time to local-time
-- 2) Converts order state to is_sale bool

select
  id,
  partner_id,
  timezone('America/Mexico_City', create_date::timestamptz) as create_date_local,
  timezone('America/Mexico_City', write_date::timestamptz) as write_date_local,
  amount_total,
  amount_paid,
  amount_tax,
  state,
  state in ('paid','done','invoiced') as is_sale
from {{ ref('odoo_stg__pos_order') }}
