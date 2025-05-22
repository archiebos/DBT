{{
    config(
        materialized='incremental',
        unique_key=['office','time']
    )
}}
select *
from {{ ref('stg_weather_data') }}

{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where time > (select max(time) from {{ this }})
{% endif %}