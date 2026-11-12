-- One row per supplier.
select
    cast(supplier_id as integer) as supplier_id,
    company_name                 as supplier_name,
    country
from {{ source('raw', 'suppliers') }}
