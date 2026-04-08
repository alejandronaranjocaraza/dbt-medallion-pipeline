select
  id,
  product_type,
  name
from {{ ref('odoo_seed__business_unit') }}
