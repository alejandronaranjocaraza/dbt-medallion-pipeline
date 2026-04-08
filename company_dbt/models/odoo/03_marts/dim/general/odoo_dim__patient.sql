select 
  surrogate_key,
  id,
  create_date_local,
  write_date_local,
  complete_name,
  active,
  birth_date,
  gender
from {{ ref('odoo_int__res_partner_patient') }}
