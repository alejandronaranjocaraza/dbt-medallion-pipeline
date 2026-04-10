with doctor_consultations_monthly as (
select * from  {{ ref('odoo_agg__doctor_consultations_monthly') }}
),
last_3months_consultations as (
select
  doctor_key as doctor_id,
  date_month,
  qty_orders
from doctor_consultations_monthly
where
date_month >= date_trunc('month',current_date) - interval '3 months'
and date_month < date_trunc('month',current_date)
order by date_month desc
),
final as (
pivot last_3months_consultations
on date_month
using sum(qty_orders)
)
select * from final
