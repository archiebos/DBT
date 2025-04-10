--IMPORT CTE

with customers as (
    select 
        *
    from {{ ref('stg_customers') }}
),

paid_order as (

    select * from {{ ref('int_orders') }}
)

,


final as (
    select

        paid_orders.order_id,
        paid_orders.customer_id,
        paid_orders.order_placed_at,
        paid_orders.order_status,

        paid_orders.total_amount_paid,
        paid_orders.payment_finalized_date,
                
        customers.customer_first_name,
        customers.customer_last_name

        -- Sales transaction sequence
        row_number() over (order by order_id) as transaction_seq,

        -- Customer sales sequence
        row_number() over (
            partition by customer_id 
            order by order_id
        ) as customer_sales_seq,

        -- New vs returning customer
        

        -- Customer lifetime value
        sum(total_amount_paid) over (
            partition by customer_id 
            order by order_placed_at
        ) as customer_lifetime_value,

        first_value(order_placed_at) over (
            partition by customer_id
            order by order_placed_at
        ) as fdos

    from paid_orders 
    left join customer on paid_order.customer_id= customer.customer_id
    
)

select * from final
