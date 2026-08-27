with encounters as (

    select
        encounter_id,
        patient_id,
        encounter_start,
        encounter_stop,
        is_inpatient,
        total_claim_cost,
        payer_coverage,
        --patient_responsibility
    from {{ ref('int_patient_encounters') }}
    where is_inpatient = true

),

covid_patients as (

    select
        patient_id,
        covid_status
    from {{ ref('int_covid_patients') }}

),

patients as (

    select
        patient_id,
        death_date
    from {{ ref('stg_patients') }}

),

ventilators as (

    select distinct
        encounter_id
    from {{ ref('stg_devices') }}
    where device_code = '449071006'

),

joined as (

    select
        e.encounter_id,
        e.patient_id,
        cp.covid_status,
        e.encounter_start,
        e.encounter_stop,
        datediff('day', e.encounter_start, e.encounter_stop) as length_of_stay_days,
        case when v.encounter_id is not null then true else false end as used_ventilator,
        case
            when p.death_date between e.encounter_start and e.encounter_stop
            then true
            else false
        end as died_during_encounter,
        e.total_claim_cost,
        e.payer_coverage,
        --e.patient_responsibility
    from encounters as e
    inner join covid_patients as cp
        on e.patient_id = cp.patient_id
    left join patients as p
        on e.patient_id = p.patient_id
    left join ventilators as v
        on e.encounter_id = v.encounter_id

)

select * from joined