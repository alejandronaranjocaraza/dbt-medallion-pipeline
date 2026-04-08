with origin as (
select
  surrogate_key,
  id,
  name,
  complete_name,
  create_date,
  write_date,
  active,
	x_studio_especialidad_1 as raw_specialty,
	x_studio_sub_especialidad_1 as raw_subspecialty,
	x_studio_fecha_de_nacimiento as birth_date,
	x_studio_gnero as gender
from {{ source('odoo','res_partner') }}
),
dedup AS (
select
  *,
  row_number() over (partition by id order by write_date desc) as dedup_id
from origin
)
select
  surrogate_key,
  id,
  name,
  complete_name,
  create_date,
  write_date,
  active,
	raw_specialty,
	raw_subspecialty,
	birth_date,
	gender
from dedup where dedup_id = 1
