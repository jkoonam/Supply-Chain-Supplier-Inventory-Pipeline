-- Singular test: an order cannot ship before it was placed.
-- dbt fails the build if this query returns any rows.
select order_id
from {{ ref('stg_orders') }}
where shipped_date is not null
  and shipped_date < order_date
