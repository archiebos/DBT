
with payments as(


    select * from

{{ ref('stg_stripe__payments') }}

)

select 
    order_id
    , sum(amount) as amount

    from payments 
    group by order_id
    
    having sum(amount)< 0 









