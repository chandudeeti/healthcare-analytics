with source as (

    select * from {{ source('raw', 'encounters') }}

),

renamed as (

    select
        id                        as encounter_id,
        "START"                   as encounter_start,
        "STOP"                    as encounter_stop,
        patient                   as patient_id,
        organization               as organization_id,
        provider                  as provider_id,
        payer                     as payer_id,
        encounterclass             as encounter_class,
        code                      as encounter_code,
        description                as encounter_description,
        base_encounter_cost,
        total_claim_cost,
        payer_coverage,
        reasoncode                 as reason_code,
        reasondescription           as reason_description,

        -- derived columns
        datediff('minute', "START", "STOP") as encounter_duration_minutes,
        total_claim_cost - payer_coverage as patient_responsibility

    from source

)

select * from renamed