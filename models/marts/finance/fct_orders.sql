
with cte as (
select 

    M.*
    , P.AMOUNT/100 as amount


    from {{ ref('stg_jaffle_shop__orders') }} M

 LEFT JOIN {{ ref('stg_stripe__payments') }} P USING (ORDER_ID))
 ,

    AGG AS (

  SELECT
    customer_id
    ,sum(amount) lifetime_amount
    
    from 

    CTE

    group by customer_id )

    SELECT 
    
    *
    

     FROM CTE
     LEFT JOIN AGG USING (CUSTOMER_ID)


  



