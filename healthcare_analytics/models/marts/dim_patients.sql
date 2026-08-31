with patients as(
    select 
        patient_id,
        birth_date,
        death_date,
        is_deceased,
        age_years, 
        gender,
        race,
        ethnicity,
        address,
        city,
        state,
        county,
        zip_code,
        healthcare_expenses,
        healthcare_coverage

    from {{ ref('stg_patients') }}
),
chronic_conditions  as (

    select 
        patient_id,
        chronic_condition_count,
        is_high_risk,
        has_hypertension,
        has_diabetes,
        has_prediabetes,
        has_coronary_heart_disease,
        has_chf,
        has_osteoporosis,
        has_hyperlipidemia,
        has_obesity,
        has_chronic_sinusitis,
        has_chronic_pain
        from {{ ref('int_patient_chronic_conditions') }}
),
covid_patients as (
    select 
        patient_id,
        covid_status,
        first_covid_diagnosis_date
    from {{ ref('int_covid_patients') }}

),
joined as (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['p.patient_id'])}} as patient_key,
        p.patient_id,
        p.birth_date,
        p.death_date,
        p.is_deceased,
        p.age_years,
        p.gender,
        p.race,
        p.ethnicity,
        p.address,
        p.city,
        p.state,
        p.county,
        p.zip_code,
        p.healthcare_expenses,
        p.healthcare_coverage,
        cc.chronic_condition_count,
        cc.is_high_risk,
        cc.has_hypertension,
        cc.has_diabetes,
        cc.has_prediabetes,
        cc.has_coronary_heart_disease,
        cc.has_chf,
        cc.has_osteoporosis,
        cc.has_hyperlipidemia,
        cc.has_obesity,
        cc.has_chronic_sinusitis,
        cc.has_chronic_pain,
        cv.covid_status,
        cv.first_covid_diagnosis_date
    from patients as p
    left join chronic_conditions as cc
        on p.patient_id = cc.patient_id
    left join covid_patients as cv
        on p.patient_id = cv.patient_id
)

select * from joined


