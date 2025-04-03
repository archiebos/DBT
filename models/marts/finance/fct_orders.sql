
select 

     M.order_id
    , M.customer_id
    , P.AMOUNT

    from {{ ref('stg_jaffle_shop__orders') }} M

 LEFT JOIN {{ ref('stg_stripe__payments') }} P
 
  ON M.ORDER_ID= P.ORDER_ID



