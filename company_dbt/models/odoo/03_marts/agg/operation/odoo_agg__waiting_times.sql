with appointments as (
select * from {{ ref('odoo_fact__appointments') }}
),
waiting_times as (
select
  appointment_id,
  doctor_key,
  patient_key,
  consulting_room_key,
  create_date_key,
  write_date_key,
  appointment_date_key,
  start_datetime_local,
  end_datetime_local,
  start_time_local,
  end_time_local,
  arrival_time_local,
  slot_type,
  state,
  is_confirmed,
  doctor_confirmed,
  is_sobreturno,
  round(date_diff('second',arrival_time_local,start_time_local)/60,2) as waiting_time,
  round(date_diff('second',start_time_local,end_time_local)/60,2) as duration,
  round(date_diff('second',start_datetime_local,end_datetime_local)/60,2) as target_duration 
from appointments
where state = 'completed'),
final as (
select
  *,
  case
    when waiting_time < 5 then '0-4'
    when waiting_time < 10 then '5-9'
    when waiting_time < 15 then '10-14'
    when waiting_time < 20 then '15-19'
    when waiting_time < 25 then '20-24'
    when waiting_time < 30 then '25-29'
    else '30+' end as waiting_category,
from waiting_times)
select
  appointment_id,
  doctor_key,
  patient_key,
  consulting_room_key,
  create_date_key,
  write_date_key,
  appointment_date_key,
  start_datetime_local,
  end_datetime_local,
  start_time_local,
  end_time_local,
  arrival_time_local,
  slot_type,
  state,
  is_confirmed,
  doctor_confirmed,
  is_sobreturno,
  waiting_time,
  duration,
  target_duration,
  waiting_category
from final
