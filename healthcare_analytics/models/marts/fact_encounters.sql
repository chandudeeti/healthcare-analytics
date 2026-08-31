with encounters as (

    select
        encounter_id,
        patient_id,
        provider_id,
        organization_id,
        payer_id,
        encounter_start,
        encounter_stop,
        encounter_duration_minutes,
        encounter_class,
        is_inpatient,
        encounter_code,
        encounter_description,
        base_encounter_cost,
        total_claim_cost,
        payer_coverage,
       -- patient_responsibility,
        reason_code,
        reason_description,
        patient_age_at_encounter
    from {{ ref('int_patient_encounters') }}

),

vitals as (

    select
        encounter_id,
        oxygen_saturation_pct,
        body_temperature,
        heart_rate,
        respiratory_rate,
        blood_pressure_systolic,
        blood_pressure_diastolic
    from {{ ref('int_encounter_vitals') }}

),

covid_conditions as (

    select distinct
        encounter_id
    from {{ ref('stg_conditions') }}
    where condition_code in ('840539006', '840544004')

),

patients as (

    select
        patient_id,
        patient_key
    from {{ ref('dim_patients') }}

),

providers as (

    select
        provider_id,
        provider_key
    from {{ ref('dim_providers') }}

),

organizations as (

    select
        organization_id,
        organization_key
    from {{ ref('dim_organizations') }}

),

payers as (

    select
        payer_id,
        payer_key
    from {{ ref('dim_payers') }}

),

joined as (

    select
        e.encounter_id,
        p.patient_key,
        pr.provider_key,
        o.organization_key,
        pa.payer_key,
        e.encounter_start,
        e.encounter_stop,
        e.encounter_duration_minutes,
        e.encounter_class,
        e.is_inpatient,
        e.encounter_code,
        e.encounter_description,
        e.base_encounter_cost,
        e.total_claim_cost,
        e.payer_coverage,
       -- e.patient_responsibility,
        e.reason_code,
        e.reason_description,
        e.patient_age_at_encounter,
        v.oxygen_saturation_pct,
        v.body_temperature,
        v.heart_rate,
        v.respiratory_rate,
        v.blood_pressure_systolic,
        v.blood_pressure_diastolic,
        case when cc.encounter_id is not null then true else false end as is_covid_encounter
    from encounters as e
    left join patients as p
        on e.patient_id = p.patient_id
    left join providers as pr
        on e.provider_id = pr.provider_id
    left join organizations as o
        on e.organization_id = o.organization_id
    left join payers as pa
        on e.payer_id = pa.payer_id
    left join vitals as v
        on e.encounter_id = v.encounter_id
    left join covid_conditions as cc
        on e.encounter_id = cc.encounter_id

)

select * from joined