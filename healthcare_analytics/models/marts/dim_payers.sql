with payers as (
    select
        payer_id,
        payer_name,
        state_headquartered,
        address,
        city,
        zip_code,
        amount_covered,
        amount_uncovered,
        revenue,
        covered_encounters,
        uncovered_encounters,
        covered_medications,
        uncovered_medications,
        covered_procedures,
        uncovered_procedures,
        covered_immunizations,
        uncovered_immunizations,
        unique_customers,
        qols_avg,
        member_months
    from {{ ref('stg_payers') }}
),
final as (
    select
        {{ dbt_utils.generate_surrogate_key(['payer_id']) }} as payer_key,
        payer_id,
        payer_name,
        state_headquartered,
        address,
        city,
        zip_code,
        amount_covered,
        amount_uncovered,
        revenue,
        covered_encounters,
        uncovered_encounters,
        covered_medications,
        uncovered_medications,
        covered_procedures,
        uncovered_procedures,
        covered_immunizations,
        uncovered_immunizations,
        unique_customers,
        qols_avg,
        member_months
    from payers
)

select * from final