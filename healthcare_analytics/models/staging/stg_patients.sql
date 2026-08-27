with source as (
    select * from {{ source('raw', 'patients') }}
),

renamed as (

    select
        id                        as patient_id,
        birthdate                 as birth_date,
        deathdate                 as death_date,
        ssn,
        drivers                   as drivers_license,
        passport                  as passport_number,
        prefix,
        first                     as first_name,
        last                      as last_name,
        suffix,
        maiden                    as maiden_name,
        marital                   as marital_status,
        race,
        ethnicity,
        gender,
        birthplace                as birth_place,
        address,
        city,
        state,
        county,
        zip                       as zip_code,
        lat                       as latitude,
        lon                       as longitude,
        healthcare_expenses,
        healthcare_coverage,

        -- derived columns
        case when deathdate is not null then true else false end as is_deceased,
        datediff('year', birthdate, coalesce(deathdate, current_date())) as age_years

    from source

)

select * from renamed