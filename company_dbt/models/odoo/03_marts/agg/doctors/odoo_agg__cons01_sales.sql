-- Aggregation layer: Consultion sales
-- **This model includes medical and
-- non-medical consultations from sales fact table*

with fact_sales as (
select
  order_line_id,
  product_key,
  create_date_key,
  company_key,
  bu_key,
  category_key,
  doctor_key,
  order_id,
  company_id,
  price_unit,
  price_subtotal,
  qty
from {{ ref('odoo_fact__sales') }}
),
dim_bu as (
select
  id,
  name
from {{ ref('odoo_dim__business_unit') }}
)
select
  fs.order_line_id,
  fs.doctor_key,
  fs.product_key,
  fs.create_date_key,
  fs.company_key,
  fs.category_key,
  fs.order_id,
  fs.company_id,
  fs.price_unit,
  fs.price_subtotal
from
fact_sales fs
left join dim_bu dbu on fs.bu_key = dbu.id
where dbu.name in ('Consulta médica','Consulta psico/nutri')
