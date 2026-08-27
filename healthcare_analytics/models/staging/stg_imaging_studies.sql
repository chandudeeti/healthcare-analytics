with source as (
    select * from {{ source('raw', 'imaging_studies') }}
),
renamed as (
    select
        id                      as imaging_study_id,
        "DATE"                  as imaging_date,
        patient                 as patient_id,
        encounter               as encounter_id,
        bodysite_code,
        bodysite_description,
        modality_code,
        modality_description,
        sop_code,
        sop_description
    from source
)
select * from renamed