-- Shipping performance by carrier.
-- Only orders that have shipped are counted. Late = shipped after the required date.
with shipped as (
    select
        o.order_id,
        o.order_date,
        o.required_date,
        o.shipped_date,
        s.shipper_name
    from {{ ref('stg_orders') }} o
    join {{ ref('stg_shippers') }} s
        on o.shipper_id = s.shipper_id
    where o.shipped_date is not null
)

select
    shipper_name,
    count(*) as shipped_orders,
    cast(sum(case when shipped_date > required_date then 1 else 0 end) as integer) as late_orders,
    round(
        100.0 * sum(case when shipped_date > required_date then 1 else 0 end) / count(*),
        1
    ) as late_rate_pct,
    round(avg(date_diff('day', order_date, shipped_date)), 1) as avg_days_to_ship
from shipped
group by shipper_name
order by late_rate_pct desc
