with dim_doctor as (
select * from {{ ref('odoo_dim__doctor') }}
),
weekly_pivot as (
select * from {{ ref('odoo_agg__doctor_consultations_weekly_pivot') }}
),
monthly_pivot as (
select * from {{ ref('odoo_agg__doctor_consultations_monthly_pivot') }}
),
doctor_metrics as (
select * from {{ ref('odoo_agg__doctor_metrics') }}
)
select
  dd.id as doctor_id,
  dd.create_date_local,
  dd.write_date_local,
  dd.complete_name,
  dd.active,
  dd.raw_specialty,
  dd.raw_subspecialty,
  dd.birth_date,
  extract(year from age(dd.birth_date)) as age,
  dd.gender,
  mp.*,
  wp.*,
  dm.active_1month,
  dm.avg_orders,
  dm.std_orders,
  dm.classification
from dim_doctor dd
left join weekly_pivot wp on wp.doctor_id=dd.id
left join monthly_pivot mp on mp.doctor_id = dd.id
left join doctor_metrics dm on dm.doctor_id = dd.id
