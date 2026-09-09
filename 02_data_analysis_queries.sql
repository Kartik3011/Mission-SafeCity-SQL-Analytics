use safety_incidents;

-- ###################################################################
--              Mission Safecity - Women's Safety
--                    Sql Data Analysis Project
-- ###################################################################

-- Objective:

-- Analyze women's safety incidents to identify:
--    common incident patterns
--    high risk locations
--    severity distribution
--    response time patterns
--    panic button usage
--    device usage
--    shift and weather patterns
--    safety infrastructure
--    advanced sql insights
--    business priorities



-- query 1: understanding the database

select 'devices' as table_name, count(*) as row_count from devices
union all
select 'incident_types', count(*) from incident_types
union all
select 'locations', count(*) from locations
union all
select 'response_outcomes', count(*) from response_outcomes
union all
select 'infrastructure', count(*) from infrastructure
union all
select 'incidents', count(*) from incidents
union all
select 'safety', count(*) from safety;


-- query 2: data quality: finding duplicate incidents
select incident_id, count(*) as duplicate_count from incidents group by incident_id having count(*) > 1;


-- query 3: data quality: missing values check
select sum(incident_id is null) as missing_incident_id, sum(date is null) as missing_date, sum(time is null) as missing_time,
    sum(location_id is null) as missing_location, sum(device_id is null) as missing_device,
    sum(incident_type_id is null) as missing_incident_type,
    sum(outcome_id is null) as missing_outcome, sum(victim_age is null) as missing_age, sum(panic_button_used is null) as missing_panic_button,
    sum(response_time_minutes is null) as missing_response_time from incidents;


-- query 4: data validation - age and response time
select min(victim_age) as minimum_age,
    max(victim_age) as maximum_age,
    round(avg(victim_age), 2) as average_age,
    min(response_time_minutes) as minimum_response_time,
    max(response_time_minutes) as maximum_response_time,
    round(avg(response_time_minutes), 2) as average_response_time from incidents;


-- query 5: kpi: key performance indicators
select
    count(*) as total_incidents,
    count(distinct location_id) as locations_affected,
    count(distinct device_id) as devices_used,
    count(distinct incident_type_id) as incident_types,
    count(distinct outcome_id) as outcomes,
    round(avg(response_time_minutes), 2) as avg_response_time,
    round(avg(victim_age), 2) as avg_victim_age,
    sum(panic_button_used = 'Yes') as panic_button_activations,
    round(sum(panic_button_used = 'Yes') * 100.0 / count(*),2 ) as panic_button_usage_percentage from incidents;


-- query 6: incident type analysis
select it.incident_type, count(*) as incident_count, round(avg(i.response_time_minutes), 2) as avg_response_time from incidents i
join incident_types it on i.incident_type_id = it.incident_type_id group by it.incident_type
order by incident_count desc;


-- query 7: severity analysis
select it.severity, count(*) as incident_count,round(count(*) * 100.0 /(select count(*) from incidents),2) as percentage_of_total,
round(avg(i.response_time_minutes), 2) as avg_response_time from incidents i
join incident_types it on i.incident_type_id = it.incident_type_id group by it.severity order by incident_count desc;


-- query 8: top 10 highest incident locations
select l.location_id, l.area_name, l.zone, l.risk_level, count(i.incident_id) as incident_count
from locations l join incidents i on l.location_id = i.location_id
group by l.location_id, l.area_name, l.zone, l.risk_level
order by incident_count desc limit 10;


-- query 9: zone and risk level analysis
select l.zone, l.risk_level, count(i.incident_id) as incident_count, round(avg(i.response_time_minutes), 2) as avg_response_time
from incidents i join locations l on i.location_id = l.location_id
group by l.zone, l.risk_level order by incident_count desc;


-- query 10: response time analysis
select min(response_time_minutes) as fastest_response, max(response_time_minutes) as slowest_response,
round(avg(response_time_minutes), 2) as average_response_time from incidents;


-- query 11: response categories
select shift,
    case
        when response_time_minutes <= 5 then '0-5 Minutes'
        when response_time_minutes <= 10 then '6-10 Minutes'
        when response_time_minutes <= 20 then '11-20 Minutes'
        else '20+ Minutes'
    end as response_category,
    count(*) as incident_count, round(avg(response_time_minutes), 2) as avg_response_time
from incidents group by shift, response_category order by incident_count desc;


-- query 12: panic button analysis
select panic_button_used, count(*) as incident_count,
round(count(*) * 100.0 / (select count(*) from incidents), 2) as percentage,
round(avg(response_time_minutes), 2) as avg_response_time
from incidents group by panic_button_used order by avg_response_time;


-- query 13: device analysis
select d.device_type, count(*) as incident_count, round(avg(i.response_time_minutes), 2) as avg_response_time,
sum(i.panic_button_used = 'Yes') as panic_button_uses
from incidents i join devices d on i.device_id = d.device_id
group by d.device_type order by incident_count desc;


-- query 14: shift analysis
select shift, count(*) as incident_count, round(avg(response_time_minutes), 2) as avg_response_time,
round(avg(witness_count), 2) as avg_witness_count
from incidents group by shift order by incident_count desc;


-- query 15: weather analysis
select weather, count(*) as incident_count, round(avg(response_time_minutes), 2) as avg_response_time
from incidents group by weather order by incident_count desc;


-- query 16: witness analysis
select
    case
        when witness_count = 0 then 'No Witnesses'
        when witness_count between 1 and 2 then '1-2 Witnesses'
        when witness_count between 3 and 5 then '3-5 Witnesses'
        else '6+ Witnesses'
    end as witness_category,
    count(*) as incident_count, round(avg(response_time_minutes), 2) as avg_response_time
from incidents group by witness_category order by incident_count desc;


-- query 17: monthly + day of the week trend
select date_format(date, '%Y-%m') as month, dayname(date) as day_name, count(*) as incident_count
from incidents group by date_format(date, '%Y-%m'), dayname(date)
order by month, incident_count desc;


-- query 18: safety infrastructure analysis
select l.area_name, l.risk_level, inf.cctv_count, inf.streetlight_count, inf.emergency_poles, inf.patrol_frequency,
count(i.incident_id) as incident_count, round(avg(i.response_time_minutes), 2) as avg_response_time
from locations l join infrastructure inf on l.location_id = inf.location_id
left join incidents i on l.location_id = i.location_id
group by l.area_name, l.risk_level, inf.cctv_count, inf.streetlight_count, inf.emergency_poles, inf.patrol_frequency
order by incident_count desc;


-- query 19: high risk locations needing attentionn
select l.location_id, l.area_name, l.risk_level, count(i.incident_id) as incident_count,
round(avg(i.response_time_minutes), 2) as avg_response_time, inf.cctv_count, inf.streetlight_count, inf.emergency_poles, inf.patrol_frequency
from locations l join infrastructure inf on l.location_id = inf.location_id
left join incidents i on l.location_id = i.location_id
group by l.location_id, l.area_name, l.risk_level, inf.cctv_count, inf.streetlight_count, inf.emergency_poles, inf.patrol_frequency
having count(i.incident_id) > 0 order by incident_count desc, avg_response_time desc;


--                  ADVANCED SQL ANALYSIS

-- query 20: rank locations by incident count (cte + dense_rank)
with location_summary as (
    select l.location_id, l.area_name, l.risk_level, count(i.incident_id) as incident_count,
    round(avg(i.response_time_minutes), 2) as avg_response_time
    from locations l left join incidents i on l.location_id = i.location_id
    group by l.location_id, l.area_name, l.risk_level
)
select *, dense_rank() over (order by incident_count desc) as location_rank
from location_summary order by location_rank;


-- query 21: most common incident type in each location (cte + row_number)
with incident_summary as (
    select l.area_name, it.incident_type, count(*) as incident_count
    from incidents i join locations l on i.location_id = l.location_id
    join incident_types it on i.incident_type_id = it.incident_type_id
    group by l.area_name, it.incident_type
),
ranked_incidents as (
    select *, row_number() over (partition by area_name order by incident_count desc) as row_num
    from incident_summary
)
select area_name, incident_type, incident_count
from ranked_incidents where row_num = 1 order by incident_count desc;


-- query 22: monthly incident change (cte + lag)
with monthly_incidents as (
    select date_format(date, '%Y-%m') as month, count(*) as incident_count
    from incidents group by date_format(date, '%Y-%m')
),
monthly_comparison as (
    select month, incident_count, lag(incident_count) over (order by month) as previous_month_incidents
    from monthly_incidents
)
select month, incident_count, previous_month_incidents,
    incident_count - previous_month_incidents as change_from_previous_month,
    round((incident_count - previous_month_incidents) * 100.0 / nullif(previous_month_incidents, 0), 2) as percentage_change
from monthly_comparison order by month;


-- query 23: cumulative incident total (window function)
with monthly_incidents as (
    select date_format(date, '%Y-%m') as month, count(*) as incident_count
    from incidents group by date_format(date, '%Y-%m')
)
select month, incident_count, sum(incident_count) over (order by month) as cumulative_incidents
from monthly_incidents order by month;


-- query 24: high severity incidents with slow response (cte)
with severe_incidents as (
    select i.incident_id, i.date, l.area_name, i.response_time_minutes, it.incident_type, it.severity
    from incidents i join incident_types it on i.incident_type_id = it.incident_type_id
    join locations l on i.location_id = l.location_id
    where it.severity = 'High'
)
select * from severe_incidents where response_time_minutes > 20
order by response_time_minutes desc;


-- query 25: final business priority analysis (cte + conditional scoring + ranking)
with location_metrics as (
    select l.location_id, l.area_name, l.risk_level, count(i.incident_id) as incident_count,
    round(avg(i.response_time_minutes), 2) as avg_response_time
    from locations l left join incidents i on l.location_id = i.location_id
    group by l.location_id, l.area_name, l.risk_level
),
priority_analysis as (
    select *,
        (
            incident_count + avg_response_time + case
                when risk_level = 'High' then 20
                when risk_level = 'Medium' then 10
                else 0
            end
        ) as priority_score
    from location_metrics
)
select *, dense_rank() over (order by priority_score desc) as priority_rank
from priority_analysis order by priority_rank;



-- total analytical queries = 25

-- basic sql:
-- select, where, group by, having, order by, limit, case, join, subqueries

-- advanced sql:
-- ctes, dense_rank(), row_number(), lag(), sum() over(),
-- window functions, conditional scoring

-- business areas:
-- data quality, kpis, incident types, severity, locations, risk,
-- response time, panic button, devices, shifts, weather, witnesses,
-- trends, infrastructure, business priorities