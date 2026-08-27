with source as (
    select * from {{ source('raw', 'devices') }}
),
renamed as (
    select
        "START"                 as device_start,
        "STOP"                  as device_stop,
        patient                 as patient_id,
        encounter               as encounter_id,
        code                    as device_code,
        description             as device_description,
        udi
    from source
)

select * from renamed