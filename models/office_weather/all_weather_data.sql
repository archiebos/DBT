{{ config(
    materialized='incremental',
    unique_key=['office','time']
)}}
SELECT *
FROM {{ref('stg_weather_data')}}
{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    WHERE time >= (SELECT MAX(time) FROM {{ this }})
{% endif %}