-- One row per product, with current stock levels.
select
    product_id,
    product_name,
    cast(supplier_id as integer)      as supplier_id,
    cast(category_id as integer)      as category_id,
    cast(unit_price as decimal(10, 2)) as unit_price,
    cast(units_in_stock as integer)   as units_in_stock,
    cast(units_on_order as integer)   as units_on_order,
    cast(reorder_level as integer)    as reorder_level,
    cast(discontinued as integer) = 1 as is_discontinued
from {{ source('raw', 'products') }}
