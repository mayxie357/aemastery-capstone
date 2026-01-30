{{ config(schema="intermediate", tags=["intermediate"]) }}

with adspend as (
    select 
        date, 
        campaign_id,     
        sum(cost_usd) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions
    from {{ ref('stg_adspend') }}
    group by all
),

order_dedup as (
    select * from {{ ref('stg_orders') }}
    qualify row_number () over (partition by order_id order by updated_at desc) = 1
),

orders as (
    select 
        order_date,
        utm_campaign,
        count(distinct order_id) as total_orders,
        sum(order_total_usd) as total_order_revenue
    from order_dedup
    group by all
)

select
    date,
    campaign_id as campaign,
    spend,
    clicks,
    impressions,
    coalesce(total_orders,0) as total_orders,
    coalesce(total_order_revenue,0) as total_order_revenue 
from adspend
left join orders
    on adspend.date = orders.order_date
    and adspend.campaign_id = orders.utm_campaign
