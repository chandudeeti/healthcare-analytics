with organizations as(
    select
        organization_id,
        organization_name,
        address,
        city,
        state,
        zip_code,
        phone,
        revenue,
        utilization
    from {{ ref('stg_organizations') }}
),
final as (
    select
        {{dbt_utils.generate_surrogate_key(['organization_id'])}} as organization_key,
        organization_id,
        organization_name,
        address,
        city,
        state,
        zip_code,
        phone,
        revenue,
        utilization
    from organizations
)

select * from final