-- Referential Integrity Check

-- 1. Does every order have a valid website_session_id?
select *
from orders o
where not exists
	(select 
		ws.website_session_id
		from website_sessions ws 
		where ws.website_session_id = o.website_session_id)

-- 2. Does every website_pageview have a valid website session id?
select *
from website_pageviews wp 
where not exists
	(select
		ws.website_session_id 
		from website_sessions ws 
		where ws.website_session_id = wp.website_session_id)	

-- 3. Does every order_item have a valid order_id?
select *
from order_items oi 
where not exists
	(select 
		o.order_id
		from orders o
		where o.order_id = oi.order_id)

-- 4. Does every order_item have a valid product_id?
select *
from order_items oi 
where not exists
	(select 
		 p.product_id
		 from products p
		 where oi.product_id = p.product_id)
	 
-- 5. Does every order's primary_product_id reference a valid product?
select *
from orders o
where not exists
	(select 
		 p.product_id
		 from products p
		 where o.primary_product_id = p.product_id)
	 
-- 6. Does every refund reference a valid order_item_id)
select *
from order_item_refunds oir 
where not exists
	(select 
		 oi.order_item_id
		 from order_items oi 
		 where oi.order_item_id = oir.order_item_id)
	 
-- 7. Does every refund reference a valid order_id
select *
from order_item_refunds oir 
where not exists
	(select 
		 o.order_id
		 from orders o 
		 where o.order_id = oir.order_id)