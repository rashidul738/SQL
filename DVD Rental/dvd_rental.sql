-- Active: 1786370343907@@127.0.0.1@5432@dvdrental
-- Rank leagues in descending order by average goals
---DVD Rental Database
SELECT
	l.name AS league,
	AVG(m.homegoal + m.awaygoal) AS avg_goals
FROM
	league AS l
	LEFT JOIN matche AS m ON l.league_id = m.league_id
GROUP BY
	league
ORDER BY
	avg_goals DESC;

---Inner Join
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	c.email,
	p.amount AS payment_amount,
	p.payment_date
FROM
	customer AS c
	INNER JOIN payment AS p ON c.customer_id = p.customer_id
ORDER BY
	p.payment_date DESC;

---Left Join
SELECT
	f.film_id,
	f.title,
	i.inventory_id
from
	film as f
	LEFT JOIN inventory AS i ON f.film_id = i.film_id
WHERE
	i.inventory_id IS NULL;

---Full Outer Join
SELECT
	f.film_id,
	f.title,
	i.inventory_id
from
	film as f
	FULL OUTER JOIN inventory AS i ON f.film_id = i.film_id
ORDER BY
	f.film_id ASC;

---Cross Join
SELECT
	*
FROM
	actor
	CROSS JOIN city;

---Natural Join
SELECT
	*
FROM
	customer
	NATURAL JOIN payment
SELECT
	*
FROM
	city
WHERE
	city != 'York';

SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	ROUND(AVG(p.amount), 2) AS avg_payment
FROM
	payment AS p
	INNER JOIN customer AS c ON p.customer_id = c.customer_id
GROUP BY
	c.customer_id
HAVING
	AVG(p.amount) > 5
ORDER BY
	c.customer_id ASC;

SELECT
	customer_id,
	COUNT(customer_id) AS payment_count
FROM
	payment
GROUP BY
	customer_id
HAVING
	COUNT(payment_id) > 40;

SELECT
	customer_id,
	MAX(amount) AS max_payment,
	MIN(amount) AS min_payment
FROM
	payment
GROUP BY
	customer_id
HAVING
	MAX(amount) > 10
ORDER BY
	max_payment DESC;

SELECT
	staff_id,
	COUNT(payment_id) AS total_rentals
FROM
	payment
GROUP BY
	staff_id;

---Create Table Product group
CREATE TABLE
	product_group (
		group_id SERIAL PRIMARY KEY,
		group_name VARCHAR(255) NOT NULL
	);

---Create Product Table
CREATE TABLE
	products (
		product_id SERIAL PRIMARY KEY,
		product_name VARCHAR(255) NOT NULL,
		price DECIMAL(11, 2),
		group_id INT NOT NULL,
		FOREIGN KEY (group_id) REFERENCES product_group (group_id)
	);

INSERT INTO
	product_group (group_name)
VALUES
	('Smart Phone'),
	('Laptop'),
	('Tablet');

INSERT INTO
	products (product_name, group_id, price)
VALUES
	('Microsoft Lumia', 1, 200),
	('HTC One', 1, 400),
	('Nexus', 1, 500),
	('Iphone', 1, 900),
	('Lenovo Thinkpad', 2, 700),
	('Sony Vaio', 2, 700),
	('Dell Vostro', 2, 800),
	('Ipad', 3, 700),
	('Samsung Galaxy Tab', 3, 200),
	('Kindle Fire', 3, 150);

SELECT
	*
FROM
	product_group;

SELECT
	*
FROM
	products;

SELECT
	ROUND(AVG(price), 2) AS avg_price
FROM
	products
GROUP BY
	group_id
HAVING
	AVG(price) > 500;



SELECT *
FROM(
	SELECT
		p1.product_name,
		p1.price,
		pg.group_name,
		ROUND(
			AVG(p1.price) OVER (
				PARTITION BY
					group_name
				ORDER BY
					p1.price DESC
			),
			2
		) AS avg_price
	FROM
		products AS p1
		INNER JOIN product_group AS pg USING (group_id)
)
WHERE avg_price >700;


---ROW NUMBER
SELECT
		p1.product_name,
		p1.price,
		pg.group_name,
		ROW_NUMBER() OVER(PARTITION BY pg.group_name ORDER BY p1.price DESC) AS rn
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id)


WITH rank_product AS(
	SELECT
		p1.product_name,
		p1.price,
		pg.group_name,
		ROW_NUMBER() OVER(PARTITION BY pg.group_name ORDER BY p1.price DESC) AS rn
	FROM products AS p1
	INNER JOIN product_group AS pg
	USING(group_id)
)

SELECT
	product_name,
	price,
	group_name
FROM rank_product
WHERE rn = 1;

---Rank
SELECT
	p1.product_name,
	p1.price,
	pg.group_name,
	RANK() OVER(PARTITION BY pg.group_name ORDER BY price)
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id);

---Dens_rank
SELECT
	p1.product_name,
	p1.price,
	pg.group_name,
	DENSE_RANK() OVER(PARTITION BY pg.group_name ORDER BY price)
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id);


---FIRST Value
SELECT
	p1.product_name,
	p1.price,
	pg.group_name,
	FIRST_VALUE(p1.price) OVER(PARTITION BY pg.group_name ORDER BY price)
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id);



---Last Value

SELECT
	p1.product_name,
	p1.price,
	pg.group_name,
	LAST_VALUE(p1.price) OVER(PARTITION BY pg.group_name ORDER BY price RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest_price_per_group
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id);


---LAG
SELECT
	p1.product_name,
	p1.price,
	pg.group_name,
	LAG(p1.price) OVER(PARTITION BY pg.group_name ORDER BY p1.price) AS pre_price,
	p1.price - LAG(p1.price, 1) OVER(PARTITION BY group_name ORDER BY p1.price) AS cur_price_diff
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id);


---LEAD
SELECT
	p1.product_name,
	p1.price,
	pg.group_name,
	LEAD(p1.price) OVER(PARTITION BY pg.group_name ORDER BY p1.price) AS next_price,
	p1.price - LEAD(p1.price, 1) OVER(PARTITION BY group_name ORDER BY p1.price) AS price_diff
FROM products AS p1
INNER JOIN product_group AS pg
USING(group_id);



CREATE TABLE monthly_sales (
    month_no INT,
    month_name VARCHAR(20),
    sales INT
);

INSERT INTO monthly_sales
VALUES
(1, 'January', 1000),
(2, 'February', 1200),
(3, 'March', 1500),
(4, 'April', 1300),
(5, 'May', 1800);






---What were the sales each month?
SELECT 
	month_name,
	sales
FROM monthly_sales


--What were the sales in the previous month?
SELECT
	month_name,
	sales,
	LAG(sales) OVER(ORDER BY sales) AS previous_month_sales
FROM monthly_sales;

--How much did sales increase or decrease?
SELECT
	month_name,
	sales,
	LAG(sales) OVER(ORDER BY month_no) AS previous_month_sales,
	sales - LAG(sales) OVER(ORDER BY month_no) AS sales_incrase_decrease
FROM monthly_sales;

SELECT
	month_name,
	sales,
	CASE 
		WHEN sales > LAG(sales) OVER(ORDER BY month_no) THEN 'Sales Increase'
		WHEN sales < LAG(sales) OVER(ORDER BY month_no) THEN 'Sales Decrease'
		ELSE  'NO Change'
		
	END AS status
FROM monthly_sales;

--Which months performed better than the previous month?
SELECT *
FROM (
	SELECT
		month_name,
		sales,
		LAG(sales) OVER(ORDER BY month_no) AS previous_sales
	FROM monthly_sales)

WHERE sales > previous_sales;


