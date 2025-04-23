{{
    config(
        materialized='view'
    )
}}

select
    p.part_num

    
from {{ source('lego', 'parts') }} as p
inner join {{ source('lego', 'inventory_parts') }} as ip on p.part_num = ip.part_num
inner join {{ source('lego', 'inventories') }} as i on i.id = ip.inventory_id
inner join {{ source('lego', 'sets') }} as s on s.set_num = i.set_num
    group by p.part_num
    having count(*) = 1
