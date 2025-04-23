WITH CTE AS (
    select 
        *
    from
        {{ ref('customer_withdrawals') }}
)
SELECT
member_name,
listagg(book_name::text, ',') as late_books,
discount_applied,
ROUND(SUM(fee_applied),2) as fee_to_pay
FROM CTE
GROUP BY 1,3