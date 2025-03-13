select
    DISTINCT stg.location_id,
    stg.location_name,
    lr.region
from {{ ref('stg_cancer_data') }} as stg
    left join {{ ref('locations_regions') }} as lr 
    on stg.location_name = lr.location_name