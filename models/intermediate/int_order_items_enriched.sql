{{ config(schema="intermediate", tags=["intermediate"]) }}

with order_items as (
    select order_id, product_sku from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
)

select
    orders.*,
    order_items.product_sku as product_sku

from orders
join order_items
    on orders.order_id = order_items.order_id