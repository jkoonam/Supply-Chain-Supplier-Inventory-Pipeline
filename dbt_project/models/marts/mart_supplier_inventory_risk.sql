-- Inventory risk by supplier.
-- A product is "at risk" when units in stock are at or below its reorder level.
-- Discontinued products are excluded.
with active_products as (
    select *
    from {{ ref('stg_products') }}
    where not is_discontinued
)

select
    s.supplier_name,
    s.country,
    count(*) as active_products,
    cast(sum(case when p.units_in_stock <= p.reorder_level then 1 else 0 end) as integer) as products_at_risk,
    round(
        100.0 * sum(case when p.units_in_stock <= p.reorder_level then 1 else 0 end) / count(*),
        1
    ) as pct_products_at_risk,
    sum(p.units_in_stock) as total_units_in_stock,
    sum(p.units_on_order) as total_units_on_order
from active_products p
join {{ ref('stg_suppliers') }} s
    on p.supplier_id = s.supplier_id
group by s.supplier_name, s.country
order by pct_products_at_risk desc, products_at_risk desc
