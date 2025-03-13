
with renamed_dalys as (
    select
        record_id,
        measure_id,
        CASE 
            WHEN measure_name like '%DALY%' then 'DALYs'
            else measure_name
        end as measure_name,
        location_id,
        location_name,
        sex_id,
        sex_name,
        cause_id,
        cause_name,
        metric_id,
        metric_name,
        year,
        val as metric_value
    from {{ source('staging','raw_cancer_data')}}
)
select * from renamed_dalys