with patients as (

    select * from {{ ref('stg_patients') }}

),

encounters as (

    select * from {{ ref('stg_encounters') }}

),

joined as (

    select
        e.encounter_id,
        e.patient_id,
        e.encounter_start,
        e.encounter_stop,
        e.encounter_duration_minutes,
        e.encounter_class,
        e.encounter_code,
        e.encounter_description,
        e.organization_id,
        e.provider_id,
        e.payer_id,
        e.base_encounter_cost,
        e.total_claim_cost,
        e.payer_coverage,
        e.patient_responsibility,
        e.reason_code,
        e.reason_description,
        p.birth_date,
        p.death_date,
        p.gender       as patient_gender,
        p.race         as patient_race,
        p.ethnicity    as patient_ethnicity
    from encounters as e
    left join patients as p
        on e.patient_id = p.patient_id

),

final as (

    select
        encounter_id,
        patient_id,
        encounter_start,
        encounter_stop,
        encounter_duration_minutes,
        encounter_class,
        case
            when lower(encounter_class) = 'inpatient' then true
            else false
        end as is_inpatient,
        encounter_code,
        encounter_description,
        organization_id,
        provider_id,
        payer_id,
        base_encounter_cost,
        total_claim_cost,
        payer_coverage,
        patient_responsibility,
        reason_code,
        reason_description,
        datediff('year', birth_date, encounter_start) as patient_age_at_encounter,
        patient_gender,
        patient_race,
        patient_ethnicity,
        case
            when death_date is not null then true
            else false
        end as is_deceased
    from joined

)

select * from final