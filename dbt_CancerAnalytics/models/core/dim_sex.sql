select
    DISTINCT
    sex_id,
    sex_name
from {{ ref('stg_cancer_data') }}