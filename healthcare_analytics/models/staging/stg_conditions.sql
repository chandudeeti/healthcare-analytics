with source as(
    select * from {{ source('raw', 'conditions') }}
),
renamed as (

    SELECT 
        "START"               as condition_start,
        "STOP"                as condition_stop,
        patient              as patient_id,
        encounter            as encounter_id,
        code                 as condition_code,
        description          as condition_description,

        from source
)

select * from renamed