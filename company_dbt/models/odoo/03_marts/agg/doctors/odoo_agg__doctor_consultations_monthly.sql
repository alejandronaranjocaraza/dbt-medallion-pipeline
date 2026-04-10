with doctor_consultations as (
select * from {{ ref('odoo_agg__doctor_consultations') }}
),
dim_date as (
select * from {{ ref('odoo_dim__date') }}
where date_day <= today()
),
dim_doctor as (
select id from {{ ref('odoo_dim__doctor') }}
),
doctor_monthly_consultations as (
select
  dc.doctor_key,
  dd.date_month,
  count(distinct dc.order_id) as qty_orders
from doctor_consultations dc
left join dim_date dd on dc.create_date_key = dd.id
group by dc.doctor_key, dd.date_month
),
base as (
select
  dda.date_month,
  ddo.id as doctor_key
from
(select distinct date_month from dim_date) dda
cross join dim_doctor ddo
),
final as (
select
  b.date_month,
  b.doctor_key,
  coalesce(dmc.qty_orders,0) as qty_orders
from base b
left join doctor_monthly_consultations dmc
on b.date_month = dmc.date_month and b.doctor_key = dmc.doctor_key
)
select
  date_month,
  doctor_key,
  qty_orders
from final
