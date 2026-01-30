{{ config(schema="intermediate", tags=["intermediate"]) }}

with order_items as (
    select order_id, product_sku from {{ ref('stg_order_items') }}
    qualify row_number () over (partition by order_id, product_sku order by line_revenue desc) = 1
),

orders as (
    select * from {{ ref('stg_orders') }}
    qualify row_number () over (partition by order_id order by updated_at desc) = 1
)

select
    orders.*,
    order_items.product_sku as product_sku

from orders
join order_items
    on orders.order_id = order_items.order_id