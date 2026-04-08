with spine as (
select unnest(
  generate_series(
    '2020-01-01'::date,
    '2050-01-01'::date,
    interval '1 day'
  ))::date as date_day
),
final as (
select
  cast(strftime(date_day, '%Y%m%d') as int) as id,
  date_day,
  date_trunc('week', date_day)::date as date_week, -- extract monday of current week
  date_trunc('month', date_day)::date as date_month,
  date_trunc('year',  date_day)::date as date_year,
  extract(year from date_day) as year,
  extract(month from date_day) as month,
  extract(day from date_day) as day,
  extract(quarter from date_day) as quarter,
  extract('dow' from date_day) as day_of_week,
  strftime(date_day, '%A') as day_name,
  strftime(date_day, '%B') as month_name,
  'Q' || extract(quarter from date_day) as quarter_name,
  date_day = current_date as is_today,
  extract('dow' from date_day) not in (0, 6) as is_weekday
from spine
)
select
  id,
  date_day,
  date_week,
  date_month,
  date_year,
  year,
  month,
  day,
  quarter,
  day_of_week,
  day_name,
  month_name,
  quarter_name,
  is_today,
  is_weekday
from final
