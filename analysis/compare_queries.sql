{% set comparison = audit_helper.compare_relations(
    a_relation=ref('customer_orders_refactored'),
    b_relation=ref('customer_orders_original'),
    primary_key='order_id'
) %}

-- You can log the result
{{ log("Equal: " ~ comparison['equal'], info=True) }}