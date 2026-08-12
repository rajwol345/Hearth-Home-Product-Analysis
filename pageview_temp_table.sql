-- Pageview tracking on a session-grain level created for downstream metrics

drop table if exists temp_session_pageview;

create temporary table temp_session_pageview as 
with ranked_pageviews as (

select 
	wp.website_session_id,
	wp.created_at,
	pageview_url, 
	stage_group,
	row_number() over (partition by wp.website_session_id order by wp.created_at) as page_order,
	count(website_pageview_id) over (partition by wp.website_session_id) as pages_visited
from website_pageviews wp)

select
    *,
    case when page_order = pages_visited then 1 else 0 end as is_last_pageview
from ranked_pageviews
