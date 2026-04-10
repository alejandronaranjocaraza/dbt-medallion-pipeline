with doctor_consultations_weekly as (
select * from  {{ ref('odoo_agg__doctor_consultations_weekly') }}
),
doctor_dim as (
select * from {{ ref('odoo_dim__doctor') }}
),
last_4weeks_consultations as (
select
  doctor_key,
  date_week,
  qty_orders
from doctor_consultations_weekly
where
date_week >= date_trunc('week',current_date) - interval '4 weeks'
and date_week < date_trunc('week',current_date)
),
doctor_metrics as (
select
  doctor_key,
  avg(qty_orders) as avg_orders,
  stddev(qty_orders) as std_orders
from last_4weeks_consultations
group by
doctor_key
),
doctor_has_been_active_for_1month as (
select
  id as doctor_id,
  create_date_local,
  create_date_local <= date_trunc('week',current_date) - interval '4 weeks' as active
  from doctor_dim
),
final as (
select
  dhbaf1m.doctor_id as doctor_id,
  dhbaf1m.active as active_1month,
  round(dm.avg_orders,2) as avg_orders,
  round(dm.std_orders,2) as std_orders
from doctor_has_been_active_for_1month dhbaf1m
left join doctor_metrics dm on dhbaf1m.doctor_id = dm.doctor_key
)
select
  doctor_id,
  active_1month,
  avg_orders,
  std_orders,
  case
    when avg_orders is null or std_orders is null or active_1month is null then 'err'
    when active_1month = false then 'N'
    when avg_orders = 0 then 'D'
    when avg_orders < 5 then 'C'
    when avg_orders < 10 then (
      case when std_orders < 5 then 'B+' else 'B' end
    )
    else (
      case when std_orders < 5 then 'A+' else 'A' end
      ) end as classification
from final
