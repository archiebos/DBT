
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
            max(created) as payment_finalized_date, 
            sum(amount) / 100.0 as total_amount_paid
    
    
     from {{ source('stripe_payments_refactor', 'payments') }}

     where status <> 'fail' group by 1

), 




--LOGICAL CTE

paid_orders as 

(  select 
    orders.order_id,
    orders.customer_id,
    orders.order_placed_at,
    orders.order_status,
    payment.total_amount_paid,
    payment.payment_finalized_date,
    customers.customer_id as customer_id,
    customers.customer_first_name,
    customers.customer_last_name

    from orders
    
    left join  payments 
        on orders.order_id = payment.order_id

    left join customers 
        on orders.customer_id = customers.customer_id 

),

customer_orders as (
    
    select 
        
        , min(order_date) as first_order_date
        , max(order_date) as most_recent_order_date
        , count(orders.order_id) as number_of_orders
    from customers

    left join orders on orders.customer_id = customers.customer_id 
    group by customers.customer_id)






-- FINAL CTE








select
    p_ord.*,
    row_number() over 
    (order by p_ord.order_id) as transaction_seq,

    row_number() over 
    (partition by customer_id 
    order by p_ord.order_id) as customer_sales_seq,

    case when customers.first_order_date = p_ord.order_placed_at
    then 'new'
    else 'return' end as nvsr,

    x.clv_bad as customer_lifetime_value,
    customers.first_order_date as fdos
from paid_orders p_ord

left join customer_orders as c using (customer_id)
left outer join 
(
    select
            p_ord.order_id,
            sum(t2.total_amount_paid) as clv_bad
    from paid_orders p_ord
    
    left join paid_orders t2 on p_ord.customer_id = t2.customer_id and p_ord.order_id >= t2.order_id
    group by 1
    order by p_ord.order_id
) 
    x on x.order_id = p_ord.order_id
    order by order_id
