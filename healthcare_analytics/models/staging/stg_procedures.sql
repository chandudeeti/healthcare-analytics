with source as (
    select * from {{ source('raw', 'procedures') }}
),
renamed as (
    select
        "DATE"                 as procedure_date,
        patient                 as patient_id,
        encounter               as encounter_id,
        code                    as procedure_code,
        description             as procedure_description,
        base_cost,
        reasoncode              as reason_code,
        reasondescription       as reason_description

    from source
)

select * from renamed