
{%- set payment_methods = ['bank_transfer','coupon', 'credit_card','gift_card'] -%}

with payments as (

    select * from {{ source('stripe_payments_refactor', 'payment') }}
),

pivoted as (

    select 
        orderid as order_id,

        {%- for payment_method in payment_methods -%}

            sum( case when payment_method = '{{ payment_method }}'  then amount else 0 end) as {{ payment_method }}_amount

        {%- if not loop.last -%}
            ,

        {%- endif %}
        {% endfor -%}
       
    
     from payments

     where status = 'success'
     group by 1
     order by 1

)

select * from pivoted