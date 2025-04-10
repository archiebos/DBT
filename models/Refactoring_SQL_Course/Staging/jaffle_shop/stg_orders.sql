
with source as (

    select

       *
    
    from {{ source('jaffle_shop_refactor', 'orders') }} 


),

transform as (

    select 

        id as order_id,
        user_id	as customer_id,
        order_date as order_placed_at,
        status as order_status
    
    from source
)

select * from transform 

