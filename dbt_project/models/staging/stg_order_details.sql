-- One row per order line item.
select
    order_id,
    product_id,
    cast(unit_price as decimal(10, 2)) as unit_price,
    cast(quantity as integer)          as quantity,
    cast(discount as decimal(5, 2))    as discount
from {{ source('raw', 'order_details') }}
