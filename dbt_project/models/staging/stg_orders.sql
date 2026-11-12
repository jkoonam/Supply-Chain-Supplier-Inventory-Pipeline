-- One row per sales order. Casts types and renames columns for downstream use.
select
    order_id,
    customer_id,
    cast(order_date as date)    as order_date,
    cast(required_date as date) as required_date,
    cast(shipped_date as date)  as shipped_date,
    cast(ship_via as integer)   as shipper_id,
    cast(freight as decimal(10, 2)) as freight,
    ship_country
from {{ source('raw', 'orders') }}
