select
    DISTINCT
    measure_id,
    measure_name
from {{ ref('stg_cancer_data') }}