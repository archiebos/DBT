with orders as (
    select 
        *
        
    from {{ ref('stg_orders') }}
),


payments as (
   select
        *
    from {{ ref('stg_payments') }}
),

complete_payments as (

    select 

        order_id,
        max(payment_created_at) as payment_finalized_date, 
        sum(payment_amount) as total_amount_paid

    from payments

    where payment_status <> 'fail'

    group by payments.order_id
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
    left join complete_payments on orders.order_id = complete_payments.order_id
    left join customers on orders.customer_id = customers.customer_id
)

select * from paid_orders