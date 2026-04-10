with waiting_times_consultations as (
select * from {{ ref('odoo_agg__waiting_times_consultations') }}
),
dim_date as (
select * from {{ ref('odoo_dim__date') }}
where date_day >= '2026-01-01'
and date_day <= today()
),
weekly_waiting_times as (
select
  dd.date_week,
  wtc.waiting_category,
  count(distinct wtc.appointment_id) as qty_appointments,
  avg(waiting_time) avg_waiting,
  avg(duration) avg_duration,
  avg(target_duration) avg_target_duration
from waiting_times_consultations wtc
left join dim_date dd on dd.id = wtc.appointment_date_key
group by date_week, waiting_category
),
base as (
select
  dd.date_week,
  wtc.* as waiting_category
from (select distinct date_week from dim_date) dd
cross join (select * from unnest(['0-4','5-9','10-14','15-19','20-24','25-29','30+'])) wtc
--cross join (select distinct waiting_category from waiting_times_consultations) wtc
),
final as (
select
  b.date_week,
  b.waiting_category,
  coalesce(mwt.qty_appointments,0) as qty_appointments,
  coalesce(mwt.avg_waiting,0) as avg_waiting,
  coalesce(mwt.avg_duration,0) as avg_duration,
  coalesce(mwt.avg_target_duration,0) as avg_target_duration
from base b
left join weekly_waiting_times mwt
using (date_week, waiting_category))
select
  date_week,
  waiting_category,
  qty_appointments,
  avg_waiting,
  avg_duration,
  avg_target_duration
from final
