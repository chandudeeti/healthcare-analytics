with source as (
    select * from {{ source('raw', 'providers') }}
),
renamed as (
    select
        id             as provider_id,
        organization    as organization_id,
        name           as provider_name,
        gender         as provider_gender,
        speciality     as provider_speciality,
        address,
        city,
        state,
        zip            as zip_code,
        lat            as latitude,
        lon            as longitude,
        utilization
    from source
)
select * from renamed