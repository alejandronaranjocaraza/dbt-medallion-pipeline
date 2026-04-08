select
partner_id,
category_id
from {{ source('odoo_rel','res_partner_res_partner_category_rel') }}
