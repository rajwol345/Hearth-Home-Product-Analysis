-- Per-session stage-reached flags (wide format), derived from temp_session_pageview
-- used for tableau funnel charts

select 
	website_session_id,
	max(case when stage_group = 'entry' then 1 else 0 end) as reached_website,
	max(case when stage_group = 'catalog' then 1 else 0 end) as reached_catalog,
	max(case when stage_group = 'product_page' then 1 else 0 end) as reached_product_page,
	max(case when stage_group = 'cart' then 1 else 0 end) as reached_cart,
	max(case when stage_group = 'shipping' then 1 else 0 end) as reached_shipping,
	max(case when stage_group = 'billing' then 1 else 0 end) as reached_billing,
	max(case when stage_group = 'order_confirmation' then 1 else 0 end) as reached_order_confirmation
from temp_session_pageview
group by website_session_id

-- Step and cumulative funnel percentages, derived from temp_session_pageview.
with stage_counts as (
select 
	stage_group,
	count(website_session_id) as sessions,
	case stage_group
		when 'entry' then 1
		when 'catalog' then 2
		when 'product_page' then 3
		when 'cart' then 4
		when 'shipping' then 5
		when 'billing' then 6
		when 'order_confirmation' then 7
	end as stage_order
from temp_session_pageview
group by stage_group
order by stage_order)

	select
	stage_group,
	sessions,
	round(sessions * 100.0 / lag(sessions) over (order by stage_order),1) as pct_step,
	round(sessions * 100.0 / first_value(sessions) over (order by stage_order),1) as pct_cumulative
from stage_counts
order by stage_order