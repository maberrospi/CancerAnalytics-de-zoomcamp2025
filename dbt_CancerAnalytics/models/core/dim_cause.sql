select
    DISTINCT
    cause_id,
    cause_name
from {{ ref('stg_cancer_data') }}