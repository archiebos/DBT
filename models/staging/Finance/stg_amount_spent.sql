
select 

    sum(amount)
    , customer_id

    from 
    {{ ref('fct_orders') }}

    group by customer_id 