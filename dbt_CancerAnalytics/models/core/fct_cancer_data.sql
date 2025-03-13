{{ config(
    materialized='table',
    partition_by={
      "field": "year_as_date",
      "data_type": "date",
      "granularity": "year"
    }
)}}


select
    record_id,
    measure_id,
    location_id,
    sex_id,
    cause_id,
    -- metric_id,
    DATE(year,1,1) as year_as_date,
    metric_value
from {{ ref('stg_cancer_data') }}

