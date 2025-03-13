{{ config(
    materialized='table',
    partition_by={
      "field": "year_as_date",
      "data_type": "date",
      "granularity": "year"
    },
    cluster_by=["location_name","cause_name"]
)}}


with joined as (
select
    tot.year_as_date,
    d_m.measure_name,
    d_s.sex_name,
    d_loc.location_name,
    d_c.cause_name,
    tot.metric_value
from {{ ref('fct_cancer_data') }} as tot
left join {{ ref('dim_location') }} as d_loc on tot.location_id=d_loc.location_id
left join {{ ref('dim_cause') }} as d_c on tot.cause_id=d_c.cause_id
left join {{ ref('dim_sex') }} as d_s on tot.sex_id=d_s.sex_id
left join {{ ref('dim_measure') }} d_m on tot.measure_id=d_m.measure_id
)

select 
    year_as_date,
    measure_name,
    location_name,
    sex_name,
    cause_name,
    metric_value as Number,
    metric_value*100/ sum(metric_value) OVER (
        PARTITION BY year_as_date, location_name, sex_name, measure_name
    ) AS Percentage
from joined