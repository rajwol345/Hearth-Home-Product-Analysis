-- 1. Orders Table

--PK check (order id)
select
	count(*),
	count(order_id),
	count(distinct order_id)
from orders

-- Data Total & Timespan
select 
	count(*) as total_orders,
	min(created_at) as first_order_date,
	max(created_at) as last_order_date
from orders o

-- Item Purchased Distribution
select 
	items_purchased,
	count(*),
	round(count(*) * 100.0 / (select count(*) from orders),2) as pct_orders
from orders
group by items_purchased
order by items_purchased

-- Product Distribution
select 
	p.product_name,
	count(order_id),
	round(count(o.order_id) * 100.0 / (select count(*) from orders o),2) as pct
from orders o
left join products p 
	on o.primary_product_id = p.product_id 
group by p.product_name
order by count(order_id) desc

-- 2. Order Items Table

-- PK check (order_item_id)
select
	count(*),
	count(order_item_id),
	count(distinct order_item_id)
from order_items oi

--customers with +1 items purchased
select 
	order_id, 
	count(*)
from order_items oi
group by 1
having count(*) > 1

-- 3. Order Item Refunds table

--PK check (order_item_refund_id)
select 
	count(*),
	count(oir.order_item_refund_id),
	count(distinct oir.order_item_refund_id )
from order_item_refunds oir

--Summary Stats
select 
	count(oir.order_item_refund_id ) as records,
	min(created_at) as first_return,
	max(created_at) as latest_return
from order_item_refunds oir

-- 4. Website Sessions Table

--PK Check (website_session_id)
select
	count(*),
	count(ws.website_session_id),
	count(distinct ws.website_session_id)
from website_sessions ws

-- Summary Stats
select
	count(ws.website_session_id),
	min(created_at),
	max(created_at)
from website_sessions ws

-- 5. Website Page Views Table

--PK Check (website_pageview_id)
select
	count(*),
	count(wp.website_pageview_id),
	count(distinct wp.website_pageview_id)
from website_pageviews wp

--Summary Stats
select
	count(wp.website_pageview_id),
	min(created_at),
	max(created_at)
from website_pageviews wp