with source as (
    select * from {{ source('raw', 'medications') }}
),
renamed as (
    select
        "START"              as medication_start,
        "STOP"               as medication_stop,
        patient              as patient_id,
        payer                as payer_id,
        encounter            as encounter_id,
        code                 as medication_code,
        description          as medication_description,
        base_cost,
        payer_coverage,
        dispenses,
        totalcost            as total_cost,
        reasoncode           as reason_code,
        reasondescription    as reason_description
    from source
)
select * from renamed