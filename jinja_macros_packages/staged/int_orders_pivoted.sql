with payments as (

    select * from {{ source('stripe_payments_refactor', 'payment') }}
),

pivoted as (

    select 
        orderid as order_id,
        sum( case when paymentmethod = 'bank_transfer' then amount else 0 end) as bank_transfer_amount,
        sum( case when paymentmethod = 'coupn' then amount else 0 end) as coupon_amount,
        sum( case when paymentmethod = 'credit_card' then amount else 0 end) as credit_card_amount,
        sum( case when paymentmethod = 'gift_card' then amount else 0 end) as gift_card_amount
    
     from payments

     where status = 'success'
     group by 1
     order by 1

)

select * from pivoted
