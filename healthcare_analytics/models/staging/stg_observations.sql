with source as (
    select * from {{ source('raw', 'observations') }}
),
renamed as (
    select
        "DATE"        as observation_date,
        patient       as patient_id,
        encounter     as encounter_id,
        code          as observation_code,
        description   as observation_description,
        value         as observation_value,
        units,
        type          as observation_type
    from source
)
select * from renamed