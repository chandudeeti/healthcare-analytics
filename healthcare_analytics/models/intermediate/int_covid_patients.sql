with patients as(
    select * from {{ ref('stg_patients') }}
),
conditions as(
    select * from {{ ref('stg_conditions') }}
),

covid_conditions as(
    select 
        patient_id,
        condition_code,
        condition_start,
        encounter_id,
        case
            when condition_code = '840539006' then 'confirmed'
            when condition_code = '840544004' then 'suspected'
        end as covid_status
    from conditions
    where condition_code in ('840539006', '840544004')
    
),

ranked_covid as (
    select 
        patient_id,
        covid_status,
        condition_start,
        encounter_id,
        row_number() over(
        partition by patient_Id
        order by
            case 
                when covid_status = 'confirmed' then 0
                when covid_status = 'suspected' then 1
            end,
            condition_start asc,
            encounter_id asc
        ) as covid_rank
    from covid_conditions
),

selected_covid as (
    select 
        patient_id,
        covid_status,
        condition_start as first_covid_diagnosis_date,
        encounter_id as covid_diagnosis_encounter_id
    from ranked_covid
    where covid_rank = 1
),

final as (
    select
        c.patient_id,
        c.covid_status,
        c.first_covid_diagnosis_date,
        c.covid_diagnosis_encounter_id,
        p.gender as patient_gender,
        p.race as patient_race,
        p.ethnicity as patient_ethnicity,
        p.birth_date as patient_birth_date,
        p.is_deceased,
    from selected_covid as c
    left join patients as p
        on c.patient_id = p.patient_id
)

select * from final