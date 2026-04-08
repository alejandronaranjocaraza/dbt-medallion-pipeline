select
  id,
  doctor_id,
  patient_id,
  consulting_room_id,
  timezone('America/Mexico_City', create_date::timestamptz) as create_date_local,
  timezone('America/Mexico_City', write_date::timestamptz) as write_date_local,
  timezone('America/Mexico_City', start_datetime::timestamptz) as start_datetime_local,
  timezone('America/Mexico_City', end_datetime::timestamptz) as end_datetime_local,
  timezone('America/Mexico_City', start_time::timestamptz) as start_time_local,
  timezone('America/Mexico_City', end_time::timestamptz) as end_time_local,
  timezone('America/Mexico_City', arrival_time::timestamptz) as arrival_time_local,
  slot_type,
  state,
  is_confirmed,
  doctor_confirmed,
  is_sobreturno
from {{ ref('odoo_scd2__appointment_slot') }}
where dbt_valid_to = '9999-12-31' -- VERIFY THIS. PREVIOUS STATES CAN BE USEFUL (3)
