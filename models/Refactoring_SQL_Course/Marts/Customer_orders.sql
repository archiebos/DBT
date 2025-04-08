
--IMPORT CTE


with orders as (

    select 
    
        id as order_id,
        user_id	as customer_id,
        order_date as order_placed_at,
        status as order_status
    
    from {{ source('jaffle_shop_refactor', 'orders') }} 
),

customers as (

    select 

        id as customer_id, 
        first_name as customer_first_name,
        last_name as customer_last_name,
        first_order_date
    
         from {{ source('jaffle_shop_refactor', 'customers') }}
),

payments as (

    select

        orderid as order_id,
        total_amount_paid,
        payment_finalized_date,
    
    * from {{ source('stripe_payments_refactor', 'payments') }}
),


--LOGICAL CTE

 complete_payments as (

    select 
        orderid as order_id,
        max(created) as payment_finalized_date, 
        sum(amount) / 100.0 as total_amount_paid
    
    from payments

    where status <> 'fail'
    
    group by 1
),

    
paid_orders as (

    select 
        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,
        complete_payments.total_amount_paid,
        complete_payments.payment_finalized_date,
        customers.customer_first_name,
        customers.customer_last_name

    from orders

    left join  
        complete_payments on orders.order_id = complete_payments.order_id

    left join customers on orders.customer_id = customers.customer_id 

),

customer_orders as (
    
    select 
        customers.customer_id as customer_id
        , min(order_date) as first_order_date
        , max(order_date) as most_recent_order_date
        , count(orders.order_id) as number_of_orders
    from customers

    left join orders on orders.customer_id = customers.customer_id 
    group by 1)


final as (

    select
        p.*,

        --Sales transaction sequence
        row_number() over 
        (order by p.order_id) as transaction_seq,

        --Customer Sales Sequence
        row_number() over(
        partition by customer_id 
        order by p.order_id
        ) as customer_sales_seq,

        --New vs returning customer
        case when customers.first_order_date = p.order_placed_at
        then 'new'
        else 'return' end as nvsr,

        x.clv_bad as customer_lifetime_value,

        --Customer lifetime value
        sum(total_amount_paid) over (
        partition by paid_orders.customer_id 
        order by paid_orders.order_placed_at
        ) as customer_lifetime_value,

        customers.first_order_date as fdos

    from paid_orders p

left join customer_orders as c using (customer_id)


    x on x.order_id = p.order_id
    order by order_id
    )


    select * from final


