select
  id,
  partner_id,
  create_date,
  write_date,
  state,
  amount_total,
  amount_paid,
  amount_tax
from {{ source('odoo','pos_order') }}
