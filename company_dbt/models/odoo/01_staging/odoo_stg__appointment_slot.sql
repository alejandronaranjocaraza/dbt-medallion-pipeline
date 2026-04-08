with origin as (
select
  id,
  slot_type,
  start_datetime,
  end_datetime,
  create_date,
  write_date,
  start_time,
  arrival_time,
  end_time,
  doctor_id,
  patient_id,
  consulting_room_id,
  state,
  is_confirmed,
  doctor_confirmed,
  is_sobreturno
from {{ source('odoo','appointment_slot') }}
),
dedup as (
select
  *,
  row_number() over (partition by id order by write_date desc) as dedup_id
from origin
)
select
  id,
  slot_type,
  start_datetime,
  end_datetime,
  create_date,
  write_date,
  start_time,
  arrival_time,
  end_time,
  doctor_id,
  patient_id,
  consulting_room_id,
  state,
  is_confirmed,
  doctor_confirmed,
  is_sobreturno
from dedup
where dedup_id = 1
