with doctor_consultations_weekly as (
select * from  {{ ref('odoo_agg__doctor_consultations_weekly') }}
),
last_4weeks_consultations as (
select
  doctor_key as doctor_id,
  date_week,
  qty_orders
from doctor_consultations_weekly
where
date_week >= date_trunc('week',current_date) - interval '4 weeks'
and date_week < date_trunc('week',current_date)
order by date_week desc
),
final as (
pivot last_4weeks_consultations
on date_week
using sum(qty_orders)
)
select * from final
