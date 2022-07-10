-------------------------------------------------
-- Data with Danny - 8 Week Challenge (Week 2) --
-- https://8weeksqlchallenge.com/case-study-2/ --
-------------------------------------------------

CREATE SCHEMA week2;
GO

/* crating runners table */
create TABLE week2.runners (runner_id int, registration_date date);
INSERT INTO week2.runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');

/* creating customer orders table */
CREATE TABLE week2.customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" datetime
);
INSERT INTO week2.customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

  /* creating runner orders table */
  CREATE TABLE week2.runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO week2.runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

  /* creating pizza names table */
  CREATE TABLE week2.pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO week2.pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

  /* creating pizza recipes table */
  CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');

/* creating pizza toppings table */
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');

  /* Data Cleanning */

  -- Step 1: Removing null values from Customer Orders Table
  select order_id, order_time, customer_id, pizza_id,
  case when exclusions like 'null' or exclusions is null then '' 
  else exclusions
  end exclusions, 
  case when extras like 'null' or extras is null then '' 
  else extras
  end extras
  into #cleaned_customer_orders
  from week2.customer_orders
  -- To view cleaned customer orders table, run the code below: 
  select * from #cleaned_customer_orders

  -- Step 2: Removing null values and expressions like "km", "mins", "minutes", etc. from runner orders table
  select [order_id], [runner_id], 
  case when [pickup_time] is null or pickup_time like 'null' then '' 
  else pickup_time end pickup_time,
  case when distance like 'null' then ''
  when distance like '%km' then TRIM('km' from distance)
  else distance end distance,
  case when [duration] like 'null' then ''
  when duration like '%minutes' then TRIM('minutes' from duration)
  when duration like '%mins' then TRIM('mins' from duration)
  when duration like '%minute' then TRIM('minute' from duration)
  else duration end duration,
  case when [cancellation] is null or cancellation like 'null' then ''
  else cancellation end cancellation
  into #cleaned_runner_orders
  from week2.runner_orders
  -- To view cleaned runner orders table, run the code below: 
  select * from #cleaned_runner_orders

  -- Step 3: Changing data types
  alter table #cleaned_runner_orders
  alter column distance float
  alter table #cleaned_runner_orders
  alter column duration int
  alter table #cleaned_runner_orders
  alter column pickup_time datetime
  alter table [week2].[pizza_names]
  alter column [pizza_name] varchar(10)
  alter table  pizza_recipes
  alter column [toppings] varchar(25)

  /* Case Study Questions
This case study has LOTS of questions - they are broken up by area of focus including:
-Pizza Metrics
-Runner and Customer Experience
-Ingredient Optimisation
-Pricing and Ratings
-Bonus DML Challenges (DML = Data Manipulation Language) */

-- A: Pizza Metrices
-----------------------------------------------------
--1-How many pizzas were ordered?
select COUNT(order_id) from #cleaned_customer_orders
--2-How many unique customer orders were made?
select COUNT(distinct order_id) from #cleaned_customer_orders
--3-How many successful orders were delivered by each runner?
select runner_id, COUNT(cancellation) from #cleaned_runner_orders
where cancellation=''
group by runner_id
--4-How many of each type of pizza was delivered?
select pizza_id, count(cancellation) from #cleaned_customer_orders
inner join #cleaned_runner_orders on #cleaned_customer_orders.order_id=#cleaned_runner_orders.order_id
where cancellation=''
group by pizza_id
--5-How many Vegetarian and Meatlovers were ordered by each customer?
select #cleaned_customer_orders.customer_id , week2.pizza_names.pizza_name, count(week2.pizza_names.pizza_name)
from #cleaned_customer_orders
join week2.pizza_names on week2.pizza_names.pizza_id=#cleaned_customer_orders.pizza_id
group by pizza_name, customer_id
--6-What was the maximum number of pizzas delivered in a single order?
select top 1 order_id, count(pizza_id) from #cleaned_customer_orders
group by order_id
order by count(pizza_id) desc
--7-For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select customer_id,
sum(case when #cleaned_customer_orders.extras='' and #cleaned_customer_orders.exclusions=''
then 1
else 0
end) nochange,
sum (case when #cleaned_customer_orders.extras <> '' or #cleaned_customer_orders.exclusions <> ''
then 1
else 0
end) atleastonechange
from #cleaned_customer_orders
join #cleaned_runner_orders on #cleaned_runner_orders.order_id=#cleaned_customer_orders.order_id
where cancellation=''
group by customer_id
--8-How many pizzas were delivered that had both exclusions and extras?
select
sum (case when #cleaned_customer_orders.extras <> '' and #cleaned_customer_orders.exclusions <> ''
then 1
else 0
end) counting
from #cleaned_customer_orders
join #cleaned_runner_orders on #cleaned_runner_orders.order_id=#cleaned_customer_orders.order_id
where cancellation=''
--9-What was the total volume of pizzas ordered for each hour of the day?
select DATEPART(HOUR, order_time) hour_of_day , COUNT(order_id) from #cleaned_customer_orders
group by DATEPART(HOUR, order_time)
--10-What was the volume of orders for each day of the week?
select DATEname(WEEKDAY, order_time) day_of_week , COUNT(order_id) from #cleaned_customer_orders
group by DATEname(WEEKDAY, order_time)
order by DATEname(WEEKDAY, order_time)

-- B: Runner and Customer Experience
-----------------------------------------------------
--1-How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
select DATEPART(week, registration_date) week_number, COUNT(runner_id) runners from week2.runners
group by DATEPART(week, registration_date)
--2-What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
select avg(DATEDIFF(MINUTE,#cleaned_runner_orders.pickup_time,#cleaned_customer_orders.order_time)) from #cleaned_customer_orders
join #cleaned_runner_orders on #cleaned_customer_orders.order_id=#cleaned_runner_orders.order_id
--3-Is there any relationship between the number of pizzas and how long the order takes to prepare?
/*select #cleaned_customer_orders.order_id, COUNT(#cleaned_customer_orders.pizza_id) number_of_pizzas, DATEDIFF(MINUTE,#cleaned_runner_orders.pickup_time,#cleaned_customer_orders.order_time) prepare_time from #cleaned_customer_orders
join #cleaned_runner_orders on #cleaned_customer_orders.order_id=#cleaned_runner_orders.order_id
group by #cleaned_customer_orders.order_id,#cleaned_customer_orders.pizza_id, #cleaned_runner_orders.pickup_time, #cleaned_customer_orders.order_time*/
--4-What was the average distance travelled for each customer?
select #cleaned_customer_orders.customer_id, avg(distance) from #cleaned_runner_orders
join #cleaned_customer_orders on #cleaned_runner_orders.order_id=#cleaned_customer_orders.order_id
where cancellation=''
group by #cleaned_customer_orders.customer_id
--5-What was the difference between the longest and shortest delivery times for all orders?
select (MAX(duration)-MIN(duration)) from #cleaned_runner_orders
where cancellation=''
--6-What was the average speed for each runner for each delivery and do you notice any trend for these values?
select order_id, runner_id, (distance/duration)*60 speed from #cleaned_runner_orders
where cancellation=''
--7-What is the successful delivery percentage for each runner?
select runner_id, 100*sum(case when cancellation='' then 1 else 0 end)/COUNT(*) from #cleaned_runner_orders
group by runner_id

-- C: Ingredient Optimisation
-----------------------------------------------------
--1-What are the standard ingredients for each pizza?

--2-What was the most commonly added extra?
select count(value) , order_id from #cleaned_customer_orders
cross apply string_split(extras, ',')
where extras<>''
group by order_id
order by count(value) desc
--3-What was the most common exclusion?
select count(value) , order_id from #cleaned_customer_orders
cross apply string_split(exclusions, ',')
where exclusions<>''
group by order_id
order by count(value) desc
--4-Generate an order item for each record in the customers_orders table in the format of one of the following:
---Meat Lovers
---Meat Lovers - Exclude Beef
---Meat Lovers - Extra Bacon
---Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
--5-Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
---For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
--6-What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?

-- C: Pricing and Ratings
-----------------------------------------------------
--1-If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
select sum(case when pizza_name='Meatlovers' then 12 else 10 end)
from #cleaned_customer_orders
join week2.pizza_names on week2.pizza_names.pizza_id=#cleaned_customer_orders.pizza_id
join #cleaned_runner_orders on #cleaned_runner_orders.order_id=#cleaned_customer_orders.order_id
where cancellation=''
--2-What if there was an additional $1 charge for any pizza extras?
---Add cheese is $1 extra
/*with extra_cte (number_of_extras, order_id) as
(select count(value), order_id from #cleaned_customer_orders
cross apply string_split(extras, ',')
where extras<>''
group by order_id
select sum(case when pizza_name='Meatlovers' then (12+COUNT(value))
else (10+COUNT(value))
end) from extra_cte
join week2.pizza_names on week2.pizza_names.pizza_id=extra_cte.order_id
join #cleaned_runner_orders on #cleaned_runner_orders.order_id=extra_cte.order_id
where cancellation=''*/
--3-The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
--4-Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
---customer_id
---order_id
---runner_id
---rating
---order_time
---pickup_time
---Time between order and pickup
---Delivery duration
---Average speed
---Total number of pizzas
--5-If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?