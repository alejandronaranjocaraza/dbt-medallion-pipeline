select
  id as appointment_id,
  doctor_id as doctor_key,
  patient_id as patient_key,
  consulting_room_id as consulting_room_key,
  cast(strftime(create_date_local,'%Y%m%d') as int) as create_date_key,
  cast(strftime(write_date_local,'%Y%m%d') as int) as write_date_key,
  cast(strftime(start_datetime_local,'%Y%m%d') as int) as appointment_date_key,
  start_datetime_local,
  end_datetime_local,
  start_time_local,
  end_time_local,
  arrival_time_local,
  slot_type,
  state,
  is_confirmed,
  doctor_confirmed,
  is_sobreturno
from {{ ref('odoo_int__appointment_slot') }}
