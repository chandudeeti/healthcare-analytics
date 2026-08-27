with source as (
    select * from {{ source('raw', 'organizations') }}
),
renamed as (
    select
        id            as organization_id,
        name          as organization_name,
        address,
        city,
        state,
        zip           as zip_code,
        lat           as latitude,
        lon           as longitude,
        phone,
        revenue,
        utilization
    from source
)
select * from renamed