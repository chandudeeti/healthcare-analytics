WITH source AS (
    SELECT * FROM {{ source('raw', 'allergies') }}
),

renamed as (

    select 
        "START"               as allergy_start,
        "STOP"                as allergy_stop,
        patient              as patient_id,
        encounter            as encounter_id,
        code                 as allergy_code,
        description          as allergy_description

        from source
)

select * from renamed