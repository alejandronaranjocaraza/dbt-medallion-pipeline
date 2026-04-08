select
  id,
  name
from {{ ref('odoo_seed__company') }}
