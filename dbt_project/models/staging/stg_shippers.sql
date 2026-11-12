-- One row per shipping company.
select
    cast(shipper_id as integer) as shipper_id,
    company_name                as shipper_name
from {{ source('raw', 'shippers') }}
