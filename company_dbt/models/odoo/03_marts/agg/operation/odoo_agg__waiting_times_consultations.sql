with waiting_times as (
select * from {{ ref('odoo_agg__waiting_times') }}
),
consulting_room_dim as (
select * from {{ ref('odoo_dim__consulting_room') }}
)
select
  wt.*
from waiting_times wt
left join consulting_room_dim crd on crd.id = wt.consulting_room_key
where crd.type = 'consulting room'
