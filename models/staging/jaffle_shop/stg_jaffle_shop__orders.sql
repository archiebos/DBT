  
with source as (
    select * from {{ source('raw_jaffle_shop', 'orders') }}
),

    transformed as (


        select 

        id as order_id,
        user_id as customer_id,
        s.order_date,
        status as order_status,

        case 
            when orders.order_status not in ('returned','return_pending') 
            then order_date end as valid_order_date,

        row_number() over (partition by user_id order by s.order_date, id) as user_order_seq
      from source s
    )
  
select * from transformed