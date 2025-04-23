
select 
    * 
from {{ source('library', 'members') }}

    where

    membership_tier is not null
    and
    membership_tier in ('Gold','Silver','Bronze')
