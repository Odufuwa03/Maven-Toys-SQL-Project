
-- Questions Set 1 ( EASY)

/* 
Q1: Which product categories drive the biggest profits? Is this the same across store locations?
*/
SELECT
	p.product_category,
	SUM((p.product_price - p.product_cost) * s.units) AS profit,
	st.store_location
FROM
	sales AS s
JOIN 
	products AS p
ON
	p.product_id = s.product_id
JOIN
	stores AS st
ON
	st.store_id = st.store_id
GROUP BY 
	p.product_category, st.store_location
ORDER BY 
	 profit DESC;
	 
/*
Q2: How much money is tied up in inventory at the toy stores? How long will it last?
*/
SELECT
	SUM(p.product_cost * i.stock_on_hand) AS total_value_inventory
FROM
	inventory AS i
JOIN
	products AS p
ON
	p.product_id = i.product_id;
	
/*
Q3: Most sale transactions (volume) by product category and location.
*/
SELECT
	p.product_category,
	st.store_location,
	COUNT (*) AS transaction_volume
FROM
	products AS p
JOIN
	sales AS s
ON
	p.product_id = s.product_id
JOIN
	stores AS st
ON
	st.store_id = s.store_id
GROUP BY
	p.product_category, st.store_location
ORDER BY 
	transaction_volume DESC

--Questions Set 2 ( MODERATE)

/*
Q4: Top 10 most revenue stores
*/
SELECT 
	st.store_name,
	SUM(p.product_price * s.units) AS revenue
FROM
	stores AS st
JOIN
	sales AS s
ON
	s.store_id = st.store_id
JOIN
	products AS p
ON
	p.product_id = s.product_id
GROUP BY
	st.store_name
ORDER BY
	revenue DESC 
LIMIT 10;

/*
Q5: Bottom 10 least revenue stores
*/
SELECT 
	st.store_name,
	SUM(p.product_price * s.units) AS revenue
FROM
	stores AS st
JOIN
	sales AS s
ON
	s.store_id = st.store_id
JOIN
	products AS p
ON
	p.product_id = s.product_id
GROUP BY
	st.store_name
ORDER BY
	revenue ASC 
LIMIT 10;

/*
Q6: Toys trends based on monthly/annual purchase per location
*/

-- Filtering Toy Sales Data
SELECT 
	s.date,
	st.store_location,
	SUM(s.units) AS units_sold
FROM 
	sales AS s
JOIN
	stores AS st
ON
	st.store_id = s.store_id
JOIN
	products AS p
ON
	p.product_id = s.product_id
WHERE
	p.product_category = 'Toys'
GROUP BY 
	s.date, st.store_location;

-- Monthly Trends:
SELECT 
	YEAR(s.date) AS year, 
	MONTH(s.date) AS month, 
	st.store_location, 
	SUM(q.quantity_sold) AS total_monthly_sales
FROM(
	SELECT 
		s.date,
		st.store_location,
		SUM(s.units) AS units_sold
	FROM 
		sales AS s
	JOIN
		stores AS st
	ON
		st.store_id = s.store_id
	JOIN
		products AS p
	ON
		p.product_id = s.product_id
	WHERE
		p.product_category = 'Toys'
	GROUP BY 
		s.date, st.store_location
) AS q
GROUP BY 
	YEAR(s.date), MONTH(s.date), st.store_location;

-- Annual Trends:
SELECT 
	YEAR(s.date) AS year,  
	st.store_location, 
	SUM(q.units_sold) AS total_monthly_sales
FROM(
	SELECT 
		s.date,
		st.store_location,
		SUM(s.units) AS units_sold
	FROM 
		sales AS s
	JOIN
		stores AS st
	ON
		st.store_id = s.store_id
	JOIN
		products AS p
	ON
		p.product_id = s.product_id
	WHERE
		p.product_category = 'Toys'
	GROUP BY 
		s.date, st.store_location
) AS q
GROUP BY 
	YEAR(s.date), st.store_location;
