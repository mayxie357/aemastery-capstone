{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['email']
    )
}}
--snapshot creates valid_from and valid_to, so we do not need the created_at_utc creates no value. 
select
    customer_id,
    full_name,
    email,
    country_code,
    updated_at_utc
from {{ ref('stg_customers') }}

{% endsnapshot %}