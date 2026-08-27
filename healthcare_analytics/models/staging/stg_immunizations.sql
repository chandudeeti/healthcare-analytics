with source as (
    select * from {{ source('raw', 'immunizations') }}
),

renaamed as (
    select
        "DATE"                  as immunization_date,
        patient                 as patient_id,
        encounter               as encounter_id,
        code                    as immunization_code,
        description             as immunization_description,
        base_cost
    from source
)

select * from renaamed