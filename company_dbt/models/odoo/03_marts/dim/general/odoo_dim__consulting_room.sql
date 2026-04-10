select
  id,
  name,
  type
from {{ ref('odoo_seed__consulting_room') }}
