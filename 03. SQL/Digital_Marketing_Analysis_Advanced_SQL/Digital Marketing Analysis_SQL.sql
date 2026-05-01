#ECOMMERCE DATABASE
USE mavenfuzzyfactory;

#TABLES
SELECT * FROM order_item_refunds;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM website_pageviews;
SELECT * FROM website_sessions;

##BUSINESS CONCEPT: TRAFFIC SOURCE ANALYSIS
#*Where your customers are coming from and which channels are driving the highest quality traffic?

#COMMON USE CASES:
#*Analyzing search data and shifting budget towards the engines, campaigns or keywords driving the strongest conversion rates.
#*Comparing user behavior patterns across traffic sources to inform creative and messaging strategy.
#*Identifying opportunities to eliminate wasted spend or scale high-converting traffic.

#TRAFFIC SOURCE ANALYSIS BASIC
#Using UTM parameters = Paid traffic is commonly tagged with tracking (UTM) parameters, which are appended to 
#URLs and allow us to tie website activity back to specific traffic sources and campaigns.

#WEBSITE SESSIONS
SELECT DISTINCT utm_source, utm_campaign
FROM website_sessions;

#Tracking Paid Campaign Revenue
SELECT utm_source,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
	COUNT(DISTINCT o.order_id) AS orders
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON o.website_session_id = ws.website_session_id
GROUP BY utm_source
ORDER BY sessions DESC;

--------------

#BUSINESS CASE 1: ANALYSING TRAFFIC SOURCES
#1. *FINDING TOP TRAFFIC SOURCES*
#Breakdown by UTM source, campaign and reffering domain

SELECT utm_source, utm_campaign, http_referer,
 COUNT(DISTINCT website_session_id) AS number_of_sessions
FROM website_sessions
WHERE created_at < '2012-04-12' -- this line is required to creat a real life business case
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY number_of_sessions DESC;

#RESULTS 1: gsearch nonbrand campaign traffic has the more sessions.  

#2. *ANALYSING TRAFFIC CONVERSION RATE*
#We need to understand if the sessions of gsearch are driving sales = conversation rate (CVR) from session to order

SELECT 
	COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS session_to_order_conv_rate
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON o.website_session_id = ws.website_session_id
WHERE ws.created_at < '2012-04-14' 
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand';

#RESULT 2: Session to order conv. rate is 0.0288, which is below the 4%. 
#Based on this analysis, we´ll need to dial down our search bids as we´re over-spending.

##BUSINESS CONCEPT: BID OPTIMIZATION
#*Understand the value of various segments of paid traffic, so that you can optimize your marketing budget.

#COMMON USE CASES:
#*Using conversion rate and revenue per click analyses to figure out how much you should spend per click to acquire customers.
#*Understanding how your website and products perform for various subsegments of traffic (i.e. mobile vs desktop) to optimize within channels.
#*Analyzing the impact that bid changes have on your ranking in the auctions, and the volume of customers driven to your site.

#3. *TRAFFIC SOURCE TRENDING*
#*gsearch nonbrand tended sessions volume by week.

SELECT
	YEARWEEK(ws.created_at) AS year_week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT ws.website_session_id) AS sessions
FROM website_sessions AS ws
WHERE ws.created_at < '2012-05-10'
	AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY year_week;

#RESULT 3: gsearch nonbrand is sensitive to bid changes. 
#We want maximum volume, but don’t want to spend more on ads than we can afford.

#4. *TRAFFIC SOURCE BID OPTIMIZATION*
#*Device-level performance: conversion rates from session to order, by device type.

SELECT ws.device_type,
	COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT ws.website_session_id) AS conv_rate
FROM website_sessions AS ws
	LEFT JOIN orders AS o
		ON o.website_session_id = ws.website_session_id
WHERE ws.created_at < '2012-05-11'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY 1;

#RESULT 4: desktop conv.rate is on 37% meamwhile mobile is just on 9%.
#We need to increase the bids on desktop to boost sales.

#5. *TRAFFIC SOURCE SEGMENT TRENDING*
#*Analyze volume by device type to see if the bid changes make a material impact: weekly trends for desktop and mobile.

SELECT
	YEARWEEK(ws.created_at) AS year_week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN ws.website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN ws.website_session_id ELSE NULL END) AS mobile_sessions
FROM website_sessions AS ws
WHERE ws.created_at < '2012-06-09'
	AND ws.created_at > '2012-04-15'
	AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY year_week;

#RESULT 5: desktop sessions are increasing thanks to the bid changes we made based on previous conversion analysis.

#NEXT STEP: NEXT STEPS:
#*Continue to monitor device-level volume and be aware of the impact bid levels has.
#*Continue to monitor conversion performance at the device-level to optimize spend.

--------------

#BUSINESS CASE 2: ANALYZING WEBSITE PERFORMANCE
#Understand which pages are seen the most by your users, to identify where to focus on improving your business.

#COMMON USE CASES:
#*Finding the most-viewed pages that customers view on your site.
#*Identifying the most common entry pages to your website – the first thing a user sees.
#*For most-viewed pages and most common entry pages, understanding how those pages perform for your business objectives.

#1. *IDENTIFYING TOP WEBSITE PAGES*
#Analyze the pageviews data and GROUP BY url to see which pages are viewed most, ranked by session volume.

SELECT pageview_url,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY pageview_url
ORDER BY sessions DESC;

#RESULT 1: The homepage, the products page, and the Mr. Fuzzy page have the most traffic.

#2. *IDENTIFYING TOP ENTRY PAGES*
# To find top entry pages, we will limit to just the first page a user sees during a given session, using a temporary table.

CREATE TEMPORARY TABLE first_pageviews
SELECT website_session_id,
	MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY website_session_id;

SELECT wp.pageview_url AS landing_page,
	COUNT(fpv.website_session_id) AS sessions_hitting_this_landing_page
FROM first_pageviews AS fpv
	LEFT JOIN website_pageviews AS wp
		ON wp.website_pageview_id = fpv.min_pageview_id
GROUP BY landing_page;

#RESULT 2: All the traffic comes through the homepage.

##BUSINESS CONCEPT: LANDING PAGE PERFORMANCE & TESTING
#Understand  the performance of your key landing pages and then testing to improve your results.

#COMMON USE CASES:
#*Identifying your top opportunities for landing pages – high volume pages with higher than expected bounce rates or low conversion rates.
#*Setting up A/B experiments on your live traffic to see if you can improve your bounce rates and conversion rates.
#*Analyzing test results and making recommendations on which version of landing pages you should use going forward.

#3. *CALCULATING BOUNCE RATES* --- multistep query
#Checking page performance: bounce rates for traffic landing on the homepage - Sessions, Bounced Sessions, Bounce Rate.

-- STEP 1: finding the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE first_pageviews
SELECT website_session_id,
	MIN(website_pageview_id) AS min_pageview_id
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY website_session_id;

SELECT * FROM first_pageviews; -- check the table

-- Step 2: identifying the landing page of each session
CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT fp.website_session_id, 
	wp.pageview_url AS landing_page
FROM first_pageviews AS fp
	LEFT JOIN website_pageviews AS wp
		ON wp.website_pageview_id = fp.min_pageview_id
WHERE wp.pageview_url = '/home';

SELECT * FROM sessions_w_home_landing_page; -- check the table

-- Step 3: counting pageviews for each session, to identify "bounces"
CREATE TEMPORARY TABLE bounced_sessions
SELECT sessions_w_home_landing_page.website_session_id,
       sessions_w_home_landing_page.landing_page,
       COUNT(wp.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews AS wp
       ON wp.website_session_id = sessions_w_home_landing_page.website_session_id
GROUP BY sessions_w_home_landing_page.website_session_id,
         sessions_w_home_landing_page.landing_page
HAVING COUNT(wp.website_pageview_id) = 1;

SELECT * FROM bounced_sessions; -- check the table

-- Step 4: summarizing by counting total sessions and bounces sessions
SELECT 
    COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) / COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
LEFT JOIN bounced_sessions
    ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id;

#RESULT 4: Almost a 60% bounce rate, which is very high - wich represent a major area of improvement.

#4. *ANALYZING LANDING PAGE TESTS* --- multistep query
#We ran a new custom landing page (/lander-1) in a 50/50 test against the homepage (/home) for our gsearch nonbrand traffic.
#Bounce rates for the two groups - time period where /lander-1 was getting traffic.

-- STEP 0: find out when the new page /lander launched
SELECT
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/lander-1'
	AND created_at IS NOT NULL;
    
#first_created_at = '2012-6-19 00:35:54'
#first_pageview_id = 23504

-- STEP 1: finding the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE first_test_pageviews AS
SELECT 
    website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM 
    website_pageviews
INNER JOIN 
    website_sessions 
    ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE 
    website_sessions.created_at < '2012-07-28'
    AND website_pageviews.website_pageview_id > 23504
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 
    website_pageviews.website_session_id;

SELECT * FROM first_test_pageviews; -- check the table

-- Step 2: identifying the landing page of each session
CREATE TEMPORARY TABLE test_sessions_w_landing_page AS
SELECT 
    first_test_pageviews.website_session_id, 
    wp.pageview_url AS landing_page
FROM first_test_pageviews
LEFT JOIN 
    website_pageviews AS wp
    ON wp.website_pageview_id = first_test_pageviews.min_pageview_id
WHERE wp.pageview_url IN ('/home', '/lander-1');

SELECT * FROM test_sessions_w_landing_page; -- check the table

-- Step 3: counting pageviews for each session, to identify "bounces"
CREATE TEMPORARY TABLE test_bounced_sessions AS
SELECT 
    tslp.website_session_id,
    tslp.landing_page,
    COUNT(wp.website_pageview_id) AS count_of_pages_viewed
FROM test_sessions_w_landing_page AS tslp
LEFT JOIN website_pageviews AS wp
    ON wp.website_session_id = tslp.website_session_id
GROUP BY 
    tslp.website_session_id,
    tslp.landing_page
HAVING 
    COUNT(wp.website_pageview_id) = 1;

SELECT * FROM test_bounced_sessions; -- check the table

-- Step 4: summarizing by counting total sessions and bounces sessions by landing page
SELECT 
    tslp.landing_page,
    COUNT(DISTINCT tslp.website_session_id) AS sessions,
    COUNT(DISTINCT tbs.website_session_id) AS bounces_sessions,
    COUNT(DISTINCT tbs.website_session_id)/COUNT(DISTINCT tslp.website_session_id) AS bounce_rates
FROM 
    test_sessions_w_landing_page AS tslp
LEFT JOIN 
    test_bounced_sessions AS tbs
    ON tslp.website_session_id = tbs.website_session_id
GROUP BY 
    tslp.landing_page;

#RESULT 4: The test lander page has a lower bounce rate - the actions were successful.

#5. *LANDING PAGE TREND ANALYSIS* --- multistep query
#Weekly overall about the paid search bounce rate trend.
#*Paid search nonbrand traffic landing on /home and /lander-1, trended weekly since June 1st.

-- STEP 1: finding the first website_pageview_id for relevant sessions
CREATE TEMPORARY TABLE sessions_w_min_pageview_id_and_view_count AS
SELECT 
    ws.website_session_id,
    MIN(wp.website_pageview_id) AS first_pageview_id,
    COUNT(wp. website_pageview_id) AS count_pageview
FROM 
    website_sessions AS ws
INNER JOIN 
    website_pageviews AS wp 
    ON ws.website_session_id = wp.website_session_id
WHERE 
    ws.created_at > '2012-06-01'
    AND ws.created_at < '2012-08-31'
    AND ws.utm_source = 'gsearch'
    AND ws.utm_campaign = 'nonbrand'
GROUP BY 
	ws.website_session_id;

SELECT * FROM sessions_w_min_pageview_id_and_view_count; -- check the table

-- Step 2: identifying the landing page of each session **AND**
-- Step 3: counting pageviews for each session, to identify "bounces"
CREATE TEMPORARY TABLE sessions_w_counts_lander_and_date AS
SELECT 
    smvc.website_session_id,
    smvc.first_pageview_id,
    smvc.count_pageview AS count_pageviews,
    wp.pageview_url AS landing_page,
    wp.created_at AS session_created_at
FROM 
    sessions_w_min_pageview_id_and_view_count AS smvc
LEFT JOIN 
    website_pageviews AS wp
    ON wp.website_pageview_id = smvc.first_pageview_id;

SELECT * FROM sessions_w_counts_lander_and_date; -- check the table

-- Step 4: summarizing by week (bounce rate, sessions to each lander page)
SELECT 
    YEARWEEK(session_created_at) AS year_week,
    MIN(DATE(session_created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) AS bounces_sessions,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) * 1.0 / COUNT(DISTINCT website_session_id) AS bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions
FROM 
    sessions_w_counts_lander_and_date 
GROUP BY 
    year_week;

#RESULT 5: Both pages were getting traffic for a while, and then we fully switched over to the new lander, as intended. 
#The overall bounce rate has come down over time which is a positive result.

##BUSINESS CONCEPT: ANALYZING & TESTING CONVERSION FUNNELS
#*Understand and optimize each step of your user’s experience on their journey toward purchasing your products.

#COMMON USE CASES:
#*Identifying the most common paths customers take before purchasing your products.
#*Identifying how many of your users continue on to each next step in your conversion flow, and how many users abandon at each step.
#*Optimizing critical pain points where users are abandoning, so that you can convert more users and sell more products.

#6. *BUILDING CONVERSION FUNNELS* --- multistep query
#When we perform conversion funnel analysis, we will look at each step in our conversion flow to see 
#how many customers drop off and how many continue on at each step.
-- Start with /lander-1 and build the funnel all the way to the thank you page. Use data since August 5th. --

-- STEP 1: select all pageviews for relevant sessions
SELECT
	website_sessions.website_session_id, 
    website_pageviews.pageview_url, 
    website_pageviews.created_at AS pageview_created_at, 
    -- CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage, -- * not relevant in this assaignment as we checked earlier
    -- CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander, -- * not relevant in this assaignment as we checked earlier
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page, 
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions 
	LEFT JOIN website_pageviews 
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch' 
	AND website_sessions.utm_campaign = 'nonbrand' 
    AND website_sessions.created_at > '2012-08-05'
		AND website_sessions.created_at < '2012-09-05'
ORDER BY 
	website_sessions.website_session_id,
    website_pageviews.created_at;
    
-- Step 2: identify each pageview as the specific funnel step
#using SUBQUERIES (same query in the parentesis () )

SELECT
	website_session_id, 
    -- MAX(homepage) AS saw_homepage, 
    -- MAX(custom_lander) AS saw_custom_lander,
    MAX(products_page) AS product_made_it, 
    MAX(mrfuzzy_page) AS mrfuzzy_made_it, 
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
	website_sessions.website_session_id, 
    website_pageviews.pageview_url, 
    website_pageviews.created_at AS pageview_created_at, 
    -- CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage, -- * not relevant in this assaignment as we checked earlier
    -- CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander, -- * not relevant in this assaignment as we checked earlier
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page, 
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions 
	LEFT JOIN website_pageviews 
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch' 
	AND website_sessions.utm_campaign = 'nonbrand' 
    AND website_sessions.created_at > '2012-08-05'
		AND website_sessions.created_at < '2012-09-05'
ORDER BY 
	website_sessions.website_session_id,
    website_pageviews.created_at) AS pageview_level
GROUP BY 
	website_session_id;

-- Step 3: create the session-level conversation funnel view
#Same query with a temporary table creation
CREATE TEMPORARY TABLE session_level_made_it_flags AS 
SELECT
	website_session_id, 
    -- MAX(homepage) AS saw_homepage, 
    -- MAX(custom_lander) AS saw_custom_lander,
    MAX(products_page) AS product_made_it, 
    MAX(mrfuzzy_page) AS mrfuzzy_made_it, 
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
	website_sessions.website_session_id, 
    website_pageviews.pageview_url, 
    website_pageviews.created_at AS pageview_created_at, 
    -- CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage, -- * not relevant in this assaignment as we checked earlier
    -- CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander, -- * not relevant in this assaignment as we checked earlier
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page, 
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions 
	LEFT JOIN website_pageviews 
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch' 
	AND website_sessions.utm_campaign = 'nonbrand' 
    AND website_sessions.created_at > '2012-08-05'
		AND website_sessions.created_at < '2012-09-05'
ORDER BY 
	website_sessions.website_session_id,
    website_pageviews.created_at) AS pageview_level
GROUP BY 
	website_session_id;

SELECT * FROM session_level_made_it_flags; -- check the table

-- Step 4: Aggregate the data to assess funnel performance
#PART 1 - aggregate data
SELECT
    COUNT(DISTINCT website_session_id) AS total_sessions, -- Total sessions analyzed
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS sessions_to_products, 
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS sessions_to_mrfuzzy, 
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS sessions_to_cart, 
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS sessions_to_shipping, 
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS sessions_to_billing, 
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS sessions_to_thankyou 
FROM 
    session_level_made_it_flags;

#PART 2 - having the rates
SELECT
	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS lander_click_rt,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS products_click_rt,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt
FROM session_level_made_it_flags;

#RESULT 6: Lowest click rates have the pages - lander, Mr.Fuzzy page and the billing page - we need to focus on these.

#7. *ANALYZING CONVERSION FUNNEL TESTS*
#What % of sessions on those pages (original and updated) end up placing an order.
#Test an updated billing page wheter /billing-2 is doing any better than the original /billing page.

SELECT
	MIN(website_pageviews.created_at) AS first_created_at,
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/billing-2';

-- first_created_at 2012-09-10 00:13:05
-- first_pageview_id: 53550

SELECT
	billing_version_seen, 
    COUNT(DISTINCT website_session_id) AS sessions, 
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rt
 FROM( 
SELECT 
	website_pageviews.website_session_id, 
    website_pageviews.pageview_url AS billing_version_seen, 
    orders.order_id
FROM website_pageviews 
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550
	AND website_pageviews.created_at < '2012-11-10' 
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
) AS billing_session_w_orders
GROUP BY 1; -- billing_version_seen

#RESULT 7: The new version of the billing page is doing a much better job converting customers.
#/billing page rate 0.45, /billing-2 rate 0.62

#NEXT STEP:  Monitor overall sales performance to see the impact this change produces.

--------------

#BUSINESS CASE 3: ANALYSIS FOR CHANNEL MANAGEMENT

##BUSINESS CONCEPT: CHANNEL PORTFOLIO OPTIMIZATION
#Bidding efficiently and using data to maximize the effectiveness of your marketing budget.


#COMMON USE CASES:
#*Understanding which marketing channels are driving the most sessions and orders through your website.
#*Understanding differences in user characteristics and conversion performance across marketing channels.
#*Optimizing bids and allocating marketing spend across a multi-channel portfolio to achieve maximum performance.

#1. *ANALYZING CHANNEL PORTFOLIOS*
#Tracking traffic from multiple marketing channels using UTM parameters in the sessions table, 
#and joining with the orders table to analyze conversions and revenue generation.

-- The company launched a second paid search channel, 'bsearch', around August 22.
#Create a weekly trended session volume and compare to 'gsearch' and 'nonbrand'

SELECT
	YEARWEEK(created_at) AS year_week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
FROM website_sessions
WHERE created_at > '2012-08-22'
	AND created_at < '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY year_week;

#RESULT 1: 'bsearch' has almost the third the traffic of 'gsearch'. This is great for a new channel.

#2. *COMPARING CHANNEL CHARACTERISTICS*
#Learn more about the bsearch nonbrand campaign - % of traffic on mobile, and compareration to gsearch.
-- aggregation date since August 22nd

SELECT
	utm_source,
    COUNT(DISTINCT website_session_id) AS total_session,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS percent_mobile
FROM website_sessions
WHERE created_at > '2012-08-22'
	AND created_at < '2012-11-30'
    AND utm_campaign = 'nonbrand'
GROUP BY 1;

#RESULT 2: gsearch has 24% mobile users meanwhile bsearch only 8% - here is clearly an improvement area compared to desktop users.

#3. *CROSS CHANNEL BID OPTIMIZATION*
#Conversion rates from session to order of nonbrand campaign for gsearch and bsearch by device type.
-- Request: analyze data from August 22 to September 18.

SELECT
	website_sessions.device_type,
    website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at > '2012-08-22'
	AND website_sessions.created_at < '2012-09-19'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2;

#RESULT 3: The different channels don´t perform idenically, so the bids needs to be differentiated.
-- action: bid down bsearch based on its under-performance.

#4. *CHANNEL PORTFOLIO TRENDS*
#Weekly session volume for gsearch and bsearch, nonbrand, broken down by device.
#Include a comparison metric to show bsearch as a % of gsearch for each device.
-- Requested: since November 4th --

SELECT
	YEARWEEK(created_at) AS year_week,
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS g_desk_topsessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS b_desk_topsessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id ELSE NULL END) AS b_pct_of_g_desktop,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS g_mob_topsessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS b_mob_topsessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END)/
		 COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id ELSE NULL END) AS b_pct_of_g_mobile
FROM website_sessions
WHERE created_at > '2012-11-04'
	AND created_at < '2012-12-22'
    AND utm_campaign = 'nonbrand'
GROUP BY year_week;

#RESULT 4: bsearch traffic dropped off a bit after the bid down. 
-- Seems like gsearch was down too after Black Friday and Cyber Monday, but bsearch dropped even more.


##BUSINESS CONCEPT: ANALYZING DIRECT TRAFFIC
#Analyzing your branded or direct traffic is about keeping a pulse on how well your brand is doing with consumers, 
#and how well your brand drives business.

#COMMON USE CASES:
#*Identifying how much revenue you are generating from direct traffic,
-- this is high margin revenue without a direct cost of customer acquisition.
#*Understanding whether or not your paid traffic is generating a “halo” effect, and promoting additional direct traffic.
#*Assessing the impact of various initiatives on how many customers seek out your business.

#5. *ANALYZING FREE CHANNELS* -- FREE TRAFFIC ANALYSIS
#Analyze traffic coming to your site that you are not paying for with marketing campaigns by identifying sessions with NULL UTM parameters.
-- Organic search, direct type in, and paid brand search sessions by month, and a % of paid search nonbrand.

SELECT
	YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END) AS brand,
    COUNT(DISTINCT CASE WHEN channel_group = 'paid_brand' THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS brand_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END) AS direct,
    COUNT(DISTINCT CASE WHEN channel_group = 'direct_type_in' THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS direct_pct_of_nonbrand,
	COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END) AS organic, 
	COUNT(DISTINCT CASE WHEN channel_group = 'organic_search' THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN channel_group = 'paid_nonbrand' THEN website_session_id ELSE NULL END) AS organic_pct_of_nonbrand
    FROM(
    SELECT
		website_session_id,
        created_at,
        CASE
			WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
            WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
            WHEN utm_campaign = 'brand' THEN 'paid_brand'
            WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
		END AS channel_group
	FROM website_sessions
    WHERE created_at < '2012-12-23') AS sessions_w_channel_group
    GROUP BY yr,mo; 

#RESULT 5: Direct and organic volume of sessions are growing on a similar % as the paid traffic.

--------------

#BUSINESS CASE 4: BUSINESS PATTERNS & SEASONALITY

##BUSINESS CONCEPT: ANALYZING SEASONALITY & BUSINESS PATTERNS
#Generating insights to help you maximize efficiency and anticipate future trends.

#COMMON USE CASES:
#*Day-parting analysis to understand how much support staff you should have at different times of day or days of the week.
#*Analyzing seasonality to better prepare for upcoming spikes or slowdowns in demand.

#1. *ANALYZING SEASONALITY*
#Monthly and weekly volume patterns, to see if there are any seasonal trends so the company should better plan for next year.
-- Requested: session volume and order volume.

SELECT 
	YEAR(website_sessions.created_at) AS yr,
	MONTH(website_sessions.created_at) AS mo, 
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions, 
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions 
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
GROUP BY 1,2;

#RESULT 1: Growing steadily, with significant volume around the holiday months (especially the weeks of Black Friday and Cyber Monday).

#2. *ANALYZING BUSINESS PATTERNS*
#Average website session volume, by hour of day and by day week, to staff appropiately to increase customer service.
-- Requested: Avoid the holiday time period and use a date range of Sep 15 - Nov 15, 2013.

SELECT
	hr,
    ROUND(AVG(CASE WHEN wkday = 0 THEN website_sessions ELSE NULL END),1) AS mon,
    ROUND(AVG(CASE WHEN wkday = 1 THEN website_sessions ELSE NULL END),1) AS tue,
	ROUND(AVG(CASE WHEN wkday = 2 THEN website_sessions ELSE NULL END),1) AS wed,
	ROUND(AVG(CASE WHEN wkday = 3 THEN website_sessions ELSE NULL END),1) AS thu,
	ROUND(AVG(CASE WHEN wkday = 4 THEN website_sessions ELSE NULL END),1) AS fri,
	ROUND(AVG(CASE WHEN wkday = 5 THEN website_sessions ELSE NULL END),1) AS sat,
	ROUND(AVG(CASE WHEN wkday = 6 THEN website_sessions ELSE NULL END),1) AS sun
FROM(
	SELECT
		DATE(created_at) AS created_date,
        WEEKDAY(created_at) AS wkday,
        HOUR(created_at) AS hr,
        COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3) daily_hourly_sessions
GROUP BY hr;

#RESULT 2: The sessions are about to doble between 8am and 5 pm from Monday to Friday. There could be discussed extra staff.

--------------

#BUSINESS CASE 5: PRODUCT ANALYSIS

##BUSINESS CONCEPT: PRODUCT SALES ANALYSIS
#Understand how each product contributes to your business, and how product launches impact the overall portfolio.

#COMMON USE CASES:
#*Analyzing sales and revenue by product.
#*Monitoring the impact of adding a new product to your product portfolio.
#*Watching product sales trends to understand the overall health of your business.

##KEY BUSINESS TERMS: ORDERS, REVENUE, MARGIN, AOV
-- ORDERS: COUNT(order_id) - Number of orders placed by customers.
-- REVENUE: SUM(price_usd) - Money the business brings in from orders.
-- MARGIN: SUM(price_usd – cogs_usd) - Revenue less the cost of good sold.
-- AOV: AVG(price_usd) - Average revenue generated per order.

SELECT 
COUNT(order_id) AS orders,
SUM(price_usd) AS revenue,
SUM(price_usd - cogs_usd) AS margin,
AVG(price_usd) AS average_order_value
FROM orders
WHERE order_id BETWEEN 100 AND 200;

#1. *PRODUCT LEVEL SALES ANALYSIS*
#Analyze order data to assess product-level sales, including order volume, revenue, and margin per product.
-- Requested: monthly trends to date for number of sales, total revenue, and total margin generated.

SELECT 
	YEAR(created_at) AS yr,
	MONTH(created_at) AS mo, 
	COUNT(DISTINCT order_id) AS number_of_sales,
    SUM(price_usd) AS total_revenue, 
    SUM(price_usd - cogs_usd) AS total_margin
FROM orders
WHERE created_at < '2013-01-04'
GROUP BY 1,2;

#RESULT 1: General growth pattern visible. This is a great baseline data to see how the revenue and margin evolve as a new product will be rolled out.

#2. *PRODUCT PRODUCT LAUNCH SALES ANALYSIS*
#Trended analysis for new launched product: monthly order volume , overall conversion rates , revenue per session , and a breakdown of sales by product.
-- Requested: the time period since April 1, 2012.

SELECT 
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo, 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
    COUNT(DISTINCT CASE WHEN primary_product_id = 1 THEN orders.order_id ELSE NULL END) AS product_1_orders,
    COUNT(DISTINCT CASE WHEN primary_product_id = 2 THEN orders.order_id ELSE NULL END) AS product_2_orders
FROM website_sessions
	LEFT JOIN orders
    ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2013-04-05'
    AND website_sessions.created_at > '2012-04-01'
GROUP BY 1, 2;

#RESULT 2: The conversion rate and revenue per session are improving over time.
-- he question is if the growth since January is due to the new product launch or just a continuation of overall business improvements.

##BUSINESS CONCEPT: PRODUCT LEVEL WEBSITE ANALYSIS
#Learn how customers interact with each of your products, and how well each product converts customers.

#COMMON USE CASES:
#*Understanding which of your products generate the most interest on multi-product showcase pages.
#*Analyzing the impact on website conversion rates when you add a new product.
#*Building product-specific conversion funnels to understand whether certain products convert better than others.


#3. *PRODUCT LEVEL WEBSITE PATHING ANALYSIS*
#Path and conversion funnel: sessions which hit the /products page and see where they went next.
-- Requested: clickthrough rates from /products since the new product launch on January 6 th 2013, 
# by product, and compare to the 3 months leading up to launch as a baseline.

-- STEP 1: find the relevant /product pageviews with website_session_id
CREATE TEMPORARY TABLE products_pageviews
SELECT
	website_session_id,
    website_pageview_id,
    created_at,
    CASE
		WHEN created_at < '2013-01-05' THEN 'A. Pre_Poduct_2'
        WHEN created_at >= '2013-01-06' THEN 'B. Post_Product_2'
        ELSE 'something wrong, check logic'
	END AS time_period
FROM website_pageviews
WHERE created_at < '2013-04-06'
	AND created_at > '2012-10-06' -- start of 3 month before product 2 launch
    AND pageview_url = '/products';
    
SELECT * FROM products_pageviews; -- check table

-- STEP 2: find the next pageview id that occurs AFTER the product pageview
CREATE TEMPORARY TABLE sessions_w_next_pageview_id
SELECT
    products_pageviews.time_period,
    products_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_next_pageview_id
FROM products_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = products_pageviews.website_session_id
		AND website_pageviews.website_pageview_id > products_pageviews.website_pageview_id
GROUP BY 1,2;

SELECT * FROM sessions_w_next_pageview_id; -- check table

-- STEP 3: find the pageview_url associated with any applicable next pageview id
CREATE TEMPORARY TABLE sessions_w_next_pageview_url
SELECT
    sessions_w_next_pageview_id.time_period,
    sessions_w_next_pageview_id.website_session_id,
    website_pageviews.pageview_url AS next_pageview_url
FROM sessions_w_next_pageview_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = sessions_w_next_pageview_id.min_next_pageview_id;

SELECT * FROM sessions_w_next_pageview_url; -- check table

-- STEP 4: summarize the data and analyze the pre vs post periods
SELECT
	time_period,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS sessions_w_next_pg,
    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT website_session_id) AS pct_w_next_pg,
	COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT website_session_id) AS pct_to_mrfuzzy,
	COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_lovebear,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT website_session_id) AS pct_to_lovebear
FROM sessions_w_next_pageview_url
GROUP BY time_period;

#RESULT 3: Looks like the percent of /products pageviews that clicked to Mr. Fuzzy has gone down since the launch of the Love Bear,
#but the overall clickthrough rate has gone up, so it seems to be generating additional product interest overall.
-- Next Step: conversion funnels for each product individually.

#4. *PRODUCT CONVERISON FUNNELS* - Building product conversion funnels
#Conversion funnels from each product page to conversion - comparison between the two conversion funnels, for all website traffic.
-- Requested: since January 6th.

-- STEP 1: slect all pageviews for relevant sessions
CREATE TEMPORARY TABLE sessions_seeing_product_pages
SELECT
	website_session_id,
    website_pageview_id,
    pageview_url AS product_page_seen
FROM website_pageviews
WHERE created_at < '2013-04-10'
	AND created_at > '2013-01-06' -- product 2 launch
    AND pageview_url IN ('/the-original-mr-fuzzy','/the-forever-love-bear');

SELECT * FROM sessions_seeing_product_pages; -- check table

-- STEP 2: figure out which pageview urls to look for
SELECT DISTINCT website_pageviews.pageview_url
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id;
    
-- STEP 3: pull all pageviews and identify the funnel steps    
#we´ll look at the inner query first to look over the pageview-level results
#then, turn it into a subquery and make it the summary with flags

SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
ORDER BY 1, website_pageviews.created_at;

-- STEP 4: create the session-level conversion funnel view
CREATE TEMPORARY TABLE sessions_product_level_made_it_flags
SELECT website_session_id,
	CASE
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		ELSE 'something wrong, check logic'
	END AS product_seen,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
	sessions_seeing_product_pages.website_session_id,
    sessions_seeing_product_pages.product_page_seen,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM sessions_seeing_product_pages
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = sessions_seeing_product_pages.website_session_id
        AND website_pageviews.website_pageview_id > sessions_seeing_product_pages.website_pageview_id
ORDER BY 1, website_pageviews.created_at) AS pageview_level
GROUP BY website_session_id,
	CASE
		WHEN product_page_seen = '/the-original-mr-fuzzy' THEN 'mrfuzzy'
        WHEN product_page_seen = '/the-forever-love-bear' THEN 'lovebear'
		ELSE 'something wrong, check logic'
	END;
    
SELECT * FROM sessions_product_level_made_it_flags; -- check table

-- STEP 5: aggregate the data to assess funnel performance
#Part 1
SELECT
	product_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
	COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM sessions_product_level_made_it_flags
GROUP BY product_seen;

#Part 2 - click rates
SELECT
	product_seen,
	COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT website_session_id) AS product_page_click_rate,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rate,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rate,
	COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rate
	FROM sessions_product_level_made_it_flags
    GROUP BY product_seen;

#RESULT 4: Adding a second product increased overall CTR (Click-Through Rate) from the /products page, and this analysis shows
#that the Love Bear has a better click rate to the /cart page and comparable rates throughout the rest of the funnel.
-- The second product was a great addition for the business.

##BUSINESS CONCEPT: CROSS-SELLING PRODUCTS - Product portfolio analysis.
#Understand which products users are most likely to purchase together, and offering smart product recommendations.

#COMMON USE CASES:
#*Understanding which products are often purchased together.
#*Testing and optimizing the way you cross-sell products on your website.
#*Understanding the conversion rate impact and the overall revenue impact of trying to crosssell additional products.

#STEPS: 
-- Analyze orders and order_items data to understand which products cross sell, and analyze the impact on revenue.
-- Use website_pageviews data to understand if cross selling hurts overall conversion rates.
-- Develop a deeper understanding of customer purchase behaviors.

SELECT
	orders.primary_product_id,
    order_items.product_id AS cross_sold_product_id,
    COUNT(DISTINCT orders.order_id) AS orders
FROM orders
	LEFT JOIN order_items
		ON orders.order_id = order_items.order_id
        AND order_items.is_primary_item = 0 -- cross sell only (exclude primary)
GROUP BY 1,2
ORDER BY 3 DESC;

#5. *CROSS SELL ANALYSIS*
#The company implemented a new option to add 2nd product while on the /cart page. 
#Compare the month before vs the month after the change, check the CTR (Click-Through Rate) from the /cart page, 
#Avg Products per Order, AOV (Average Order Value), and overall revenue per /cart page view.
-- Implementation date: September 25th  

-- STEP 1: Identify the relevant /cart page view and their sessions
CREATE TEMPORARY TABLE sessions_seeing_cart
SELECT
	CASE
		WHEN created_at < '2013-09-25' THEN 'A. Pre_Cross_Sell'
        WHEN created_at >= '2013-01-06' THEN 'B. Post_Cross_Sell'
        ELSE 'something wrong, check logic'
	END AS time_period,
    website_session_id AS cart_session_id,
    website_pageview_id AS cart_pageviews_id
FROM website_pageviews
WHERE created_at BETWEEN '2013-08-25' AND '2013-10-25'
	AND pageview_url = '/cart';
    
SELECT * FROM sessions_seeing_cart; -- check table

-- STEP 2: See which of those /cart sessions clicked through to the shipping page
CREATE TEMPORARY TABLE cart_sessions_seeing_another_page AS
SELECT 
    sessions_seeing_cart.time_period,
    sessions_seeing_cart.cart_session_id, 
    MIN(website_pageviews.website_pageview_id) AS pv_id_after_cart
FROM sessions_seeing_cart
LEFT JOIN website_pageviews
    ON website_pageviews.website_session_id = sessions_seeing_cart.cart_session_id
    AND website_pageviews.website_pageview_id > sessions_seeing_cart.cart_pageviews_id -- pageviews happened after seeing the cart
GROUP BY sessions_seeing_cart.time_period, sessions_seeing_cart.cart_session_id
HAVING 
    MIN(website_pageviews.website_pageview_id) IS NOT NULL;

SELECT * FROM cart_sessions_seeing_another_page; -- check table

-- STEP 3: Find the orders associated with the /cart sessions. Analyze products purchased, AOV
CREATE TEMPORARY TABLE pre_post_sessions_orders
SELECT
	time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
FROM sessions_seeing_cart
	INNER JOIN orders
		ON sessions_seeing_cart.cart_session_id = orders.website_session_id;

SELECT * FROM pre_post_sessions_orders; -- check table

-- first, we´ll look at this select statement
-- then we´ll turn it into a subquery

SELECT 
    sessions_seeing_cart.time_period,
    sessions_seeing_cart.cart_session_id, 
    CASE WHEN cart_sessions_seeing_another_page.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
    CASE WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
    pre_post_sessions_orders.items_purchased,
    pre_post_sessions_orders.price_usd
FROM sessions_seeing_cart
	LEFT JOIN cart_sessions_seeing_another_page
		ON sessions_seeing_cart.cart_session_id = cart_sessions_seeing_another_page.cart_session_id
	LEFT JOIN pre_post_sessions_orders
		ON sessions_seeing_cart.cart_session_id = pre_post_sessions_orders.cart_session_id
ORDER BY cart_session_id;

-- STEP 4: Aggregate and analyze a summary of our findings
SELECT
	time_period,
    COUNT(DISTINCT cart_session_id) AS cart_sessions,
    SUM(clicked_to_another_page) AS clickthroughs,
    SUM(clicked_to_another_page)/COUNT(DISTINCT cart_session_id) AS cart_ctr,
    -- SUM(placed_orders) AS orders_placed,
    -- SUM(items_purchased) AS products_purchased,
    SUM(items_purchased)/SUM(placed_order) AS products_per_order,
    -- SUM(price_usd) AS revenue,
    SUM(price_usd)/SUM(placed_order) AS aov,
    SUM(price_usd)/COUNT(DISTINCT cart_session_id) AS rev_per_cart_session
FROM(
SELECT 
    sessions_seeing_cart.time_period,
    sessions_seeing_cart.cart_session_id, 
    CASE WHEN cart_sessions_seeing_another_page.cart_session_id IS NULL THEN 0 ELSE 1 END AS clicked_to_another_page,
    CASE WHEN pre_post_sessions_orders.order_id IS NULL THEN 0 ELSE 1 END AS placed_order,
    pre_post_sessions_orders.items_purchased,
    pre_post_sessions_orders.price_usd
FROM sessions_seeing_cart
	LEFT JOIN cart_sessions_seeing_another_page
		ON sessions_seeing_cart.cart_session_id = cart_sessions_seeing_another_page.cart_session_id
	LEFT JOIN pre_post_sessions_orders
		ON sessions_seeing_cart.cart_session_id = pre_post_sessions_orders.cart_session_id
ORDER BY cart_session_id) AS full_data
GROUP BY time_period;

#RESULT 5: CTR from the /cart page didn’t go down, and that our products per order, AOV, 
#and revenue per /cart session are all up slightly since the cross sell feature was added.

#6. *PORTFOLIO EXPANSION ANALYSIS*
#Pre post analysis comparing the month before vs. the month after, in terms of session to order conversion rate, 
#AOV, products per order, and revenue per session.
-- Third product implementation date: December 12th - 'Birthday Bear'

SELECT
	CASE
		WHEN website_sessions.created_at < '2013-12-12' THEN 'A. Pre_Birthday_Bear'
        WHEN website_sessions.created_at >= '2013-12-12' THEN 'B. Post_Birthday_Bear'
		ELSE 'something wrong, check logic'
	END AS time_period,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) AS total_revenue,
    SUM(orders.items_purchased) AS total_products_sold,
    SUM(orders.price_usd)/COUNT(DISTINCT orders.order_id) AS average_order_value,
    SUM(orders.items_purchased)/COUNT(DISTINCT orders.order_id) AS products_per_order,
    SUM(orders.price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2013-11-12' AND '2014-01-12'
GROUP BY 1;

#RESULT 6: All the critical metrics have improved since the new product launch.

##BUSINESS CONCEPT: PRODUCT REFUND ANALYSIS
#Quality control and understanding where you might have problems to address.
-- Analyze the relative quality of your products, track customer satisfaction, and keep a pulse on overall business health.

#COMMON USE CASES:
#*Monitoring products from different suppliers.
#*Understanding refund rates for products at different price points.
#*Taking product refund rates and the associated costs into account when assessing the overall performance of your business.

#7. *PRODUCT REFUND RATES* - Quality issues and refunds
#Monthly product refund rates, by product, and confirm our quality issues are now fixed.
-- Situation: Mr. Fuzzy supplier had some quality issues which weren’t corrected until September 2013.
-- Then they had a major problem where the bears’ arms were falling off in Aug/Sep 2014. 
-- As a result, the company replaced them with a new supplier on September 16, 2014.

SELECT 
	YEAR(order_items.created_at) AS yr,
	MONTH(order_items.created_at) AS mo, 
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS p1_orders,
    COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_item_refunds.order_item_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS p1_refund_rate,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_items.order_item_id ELSE NULL END) AS p2_orders,
    COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_item_refunds.order_item_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN product_id = 2 THEN order_items.order_item_id ELSE NULL END) AS p2_refund_rate,
    COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_items.order_item_id ELSE NULL END) AS p3_orders,
    COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_item_refunds.order_item_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN product_id = 3 THEN order_items.order_item_id ELSE NULL END) AS p3_refund_rate,
    COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_items.order_item_id ELSE NULL END) AS p4_orders,
    COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_item_refunds.order_item_id ELSE NULL END)/
		COUNT(DISTINCT CASE WHEN product_id = 4 THEN order_items.order_item_id ELSE NULL END) AS p4_refund_rate
FROM order_items 
	LEFT JOIN order_item_refunds
		ON order_items.order_item_id = order_item_refunds.order_item_id
WHERE order_items.created_at < '2014-10-15'
GROUP BY 1,2;

#RESULT 7: The refund rates for Mr. Fuzzy did go down after the initial improvements in September 2013, but
#refund rates were terrible in August and September, as expected (13 14%).
#The new supplier is doing much better so far, and the other products look okay too.

--------------

#BUSINESS CASE 6: USER-LEVEL ANALYSIS

##BUSINESS CONCEPT: ANALYZE REPEAT BEHAVIOR
#Understand user behavior and identify some of your most valuable customers.

#COMMON USE CASES:
#*Analyzing repeat activity to see how often customers are coming back to visit your site.
#*Understanding which channels they use when they come back, and whether or not you are paying for them again through paid channels.
#*Using your repeat visit activity to build a better understanding of the value of a customer in order to better optimize marketing channels.

##TRACKING REPEAT CUSTOMERS ACROSS MULTIPLE SESSIONS
-- Businesses track customer behavior across multiple sessions using browser cookies.
-- Cookies have unique ID values associated with them, which allows us to recognize 
-- a customer when they come back and track their behavior over time.

#1. *IDENTIFYING REPEAT VISITORS*
#How many of the website visitors come back for another session. Find the most valuable customers.
-- Requested: 2014 to date (2014-11-01)

-- STEP 1: Identify the relevant new sessions -- subquery
-- STEP 2: USE the user_id values from Step 1 to find any repeat sessions those users had
CREATE TEMPORARY TABLE sessions_w_repeats
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM
(
SELECT 
		user_id,
        website_session_id
	FROM website_sessions
    WHERE created_at < '2014-11-01'
		AND created_at >= '2014-01-01'
		AND is_repeat_session = 0 -- new sessions only
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1 
        AND website_sessions.website_session_id > new_sessions.website_session_id -- session was later than new session
        AND website_sessions.created_at < '2014-11-01'
        AND website_sessions.created_at >= '2014-01-01';
        
SELECT * FROM sessions_w_repeats; -- check table

-- STEP 3: Analyze the data at the user level (how many sessions did each user have?) -- subquery
-- STEP 4: Aggregate the user-level analysisi to generate your behavioral analysis
SELECT 
	repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM(
	SELECT
		user_id,
        COUNT(DISTINCT new_session_id) AS new_sessions,
        COUNT(DISTINCT repeat_session_id) AS repeat_sessions
	FROM sessions_w_repeats
    GROUP BY 1
    ORDER BY 3 DESC) AS user_level
GROUP BY 1;

#RESULT 1: Customers do come back to the site after the first session wich is great.

#2. *ANALYZING REPEAT BEHAVIOR*
#Understand the behavior of repeat customers - the minimum, maximum, and average time between the first and second session for repeated customers.
-- Requested: 2014 to date (2014-11-03)

-- STEP 1: Identify the relevant new sessions -- subquery
-- STEP 2: USE the user_id values from Step 1 to find any repeat sessions those users had
CREATE TEMPORARY TABLE sessions_w_repeats_for_time_diff
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    new_sessions.created_at AS new_session_created_at,
    website_sessions.website_session_id AS repeat_session_id,
    website_sessions.created_at AS repeat_session_created_at
FROM
(
SELECT 
		user_id,
        website_session_id,
        created_at
	FROM website_sessions
    WHERE created_at < '2014-11-03'
		AND created_at >= '2014-01-01'
		AND is_repeat_session = 0 -- new sessions only
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1 
        AND website_sessions.website_session_id > new_sessions.website_session_id -- session was later than new session
        AND website_sessions.created_at < '2014-11-03'
        AND website_sessions.created_at >= '2014-01-01';
        
SELECT * FROM sessions_w_repeats_for_time_diff; -- check table

-- STEP 3: Find the created_at times for first and second sessions -- subquery
-- STEP 4: Find the differences between first and second sessions at a user level
CREATE TEMPORARY TABLE users_first_to_second
SELECT
	user_id,
    DATEDIFF(second_session_created_at, new_session_created_at) AS days_first_to_second_session
FROM (
	SELECT 
		user_id,
        new_session_id,
        new_session_created_at,
        MIN(repeat_session_id) AS second_session_id,
        MIN(repeat_session_created_at) AS second_session_created_at
	FROM sessions_w_repeats_for_time_diff
    WHERE repeat_session_id IS NOT NULL
    GROUP BY 1,2,3
) AS first_second;

SELECT * FROM users_first_to_second; -- check table

-- STEP 5: Aggregate the user level data to find the average, min, max
SELECT
	AVG(days_first_to_second_session) AS avg_days_first_to_second,
    MIN(days_first_to_second_session) AS min_days_first_to_second,
    MAX(days_first_to_second_session) AS max_days_first_to_second
FROM users_first_to_second;

#RESULT 2: Repeat visitors are coming back about a month later, on average.
#AVG days until return to the channel 33 days, MIN is 1 day and MAX is 69 days.

#3. *NEW VS REPEAT CHANNEL PATTERNS*
#Understand the channels repeat customers come back through. Are they direct type-in or through paid search ads.
#Compare new vs. repeat sessions by channel.
-- Requested: 2014 to date (2014-11-05)

SELECT
	CASE
		WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN 'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        WHEN utm_source IS NULL AND http_referer IS NULL THEN 'direct_type_in'
        WHEN utm_source = 'socialbook' THEN 'paid_social'
	END AS channel_group,
    COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE created_at < '2014-11-05'
	AND created_at >= '2014-01-01'
GROUP BY 1
ORDER BY 3 DESC;

#RESULT 2: When customers come back for repeat visits, they come mainly through organic search, direct type in, and paid brand.
#Only about 1/3 come through a paid channel.
#Next step: Are these repeat visits convert to orders?

#4. *NEW VS REPEAT CHANNEL PATTERNS*
#Comparison of conversion rates and revenue per session for repeat sessions vs new sessions.
-- Requested: 2014 year to date (2014-11-08)

SELECT
	is_repeat_session,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2014-11-08'
	AND website_sessions.created_at >= '2014-01-01'
GROUP BY 1;

#RESULT 4: Repeat sessions are more likely to convert , and produce more revenue per session.
#MARKETING ACTION: Take into account repeated customers when bidding on paid traffic.

