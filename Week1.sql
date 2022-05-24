create table week1.sales (
customer_id varchar(1),
order_date date,
product_id int);

insert into week1.sales (
customer_id, 
order_date, 
product_id)
values ('A', '2021-01-01', 1),
       ('A', '2021-01-01', 2),
       ('A', '2021-01-07', 2),
       ('A', '2021-01-10', 3),
	   ('A', '2021-01-11', 3),
	   ('A', '2021-01-11', 3),
       ('B', '2021-01-01', 2),
       ('B', '2021-01-02', 2),
       ('B', '2021-01-04', 1),
       ('B', '2021-01-11', 1),
       ('B', '2021-01-16', 3),
       ('B', '2021-02-01', 3),
       ('C', '2021-01-01', 3),
       ('C', '2021-01-01', 3),
       ('C', '2021-01-07', 3);

create table week1.menu (
product_id int, 
product_name varchar(5),
price int);

insert into week1.menu (
product_id,
product_name,
price)
values (1,'sushi',10),
       (2,'curry', 15),
	   (3,'ramen', 12);

create table week1.members (
customer_id varchar(1), 
join_date date);

insert into week1.members (
customer_id,
join_date)
values ('A','2021-01-07'),
('B','2021-01-09');

/* --------------------

   Case Study Questions

   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
      select  week1.sales.customer_id , sum (price) total_spent from week1.sales
      inner join week1.menu on week1.sales.product_id=week1.menu.product_id
	  group by week1.sales.customer_id

-- 2. How many days has each customer visited the restaurant?
      select customer_id, count(distinct order_date) number_of_days from week1.sales
	  group by week1.sales.customer_id

-- 3. What was the first item from the menu purchased by each customer?
      with cteranking as
	 (select customer_id, product_name, order_date,
	 dense_rank () over (partition by customer_id order by order_date) ranking from week1.sales
	 inner join week1.menu on week1.menu.product_id=week1.sales.product_id)
	 select customer_id, product_name, order_date from cteranking
	 where ranking = 1

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
     select product_name as most_purchased_item , count(product_name) as total_purchased from week1.sales
	 inner join week1.menu on week1.menu.product_id=week1.sales.product_id
	 group by product_name
	 order by total_purchased desc
	 offset 0 rows fetch first 1 rows only
	 
-- 5. Which item was the most popular for each customer?
     with cteranking as
	 (select customer_id, product_name, count(product_name) total,
	 rank () over (partition by customer_id order by count(product_name) desc) ranking from week1.sales
	 inner join week1.menu on week1.menu.product_id=week1.sales.product_id
	 group by customer_id, product_name)
	 select * from cteranking
	 where ranking=1

-- 6. Which item was purchased first by the customer after they became a member?
     with cteranking as
	 (select week1.sales.customer_id, order_date, product_name,join_date, 
	 RANK() over (partition by week1.sales.customer_id order by order_date) ranking 
	 from week1.sales
	 inner join week1.members on week1.sales.customer_id=week1.members.customer_id
	 inner join week1.menu on week1.sales.product_id=week1.menu.product_id
	 where week1.sales.order_date>=week1.members.join_date 
	 )
	 select * from cteranking
	 where ranking=1

-- 7. Which item was purchased just before the customer became a member?
     with cteranking as
	 (select week1.sales.customer_id, order_date, product_name, 
	 dense_RANK() over (partition by week1.sales.customer_id order by order_date desc) ranking 
	 from week1.sales
	 inner join week1.members on week1.sales.customer_id=week1.members.customer_id
	 inner join week1.menu on week1.sales.product_id=week1.menu.product_id
	 where week1.sales.order_date<week1.members.join_date 
	 )
	 select * from cteranking
	 where ranking=1

-- 8. What is the total items and amount spent for each member before they became a member?
      select  week1.sales.customer_id, sum (price) total_spent,COUNT(sales.product_id) total_items from week1.sales
      inner join week1.menu on week1.sales.product_id=week1.menu.product_id
	  inner join week1.members on week1.sales.customer_id=week1.members.customer_id
	  where week1.sales.order_date<week1.members.join_date 
	  group by week1.sales.customer_id

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
     with ctepoints as
	 (select *, case when product_name='sushi' then (price*20)
	 else price*10
	 end points
	 from week1.menu)
	 select customer_id, sum(points) sum_of_points from ctepoints
	 inner join week1.sales on week1.sales.product_id = ctepoints.product_id
	 group by customer_id

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
     with ctepoints as
	 (select week1.sales.customer_id, week1.sales.product_id, week1.sales.order_date, week1.members.join_date, week1.menu.price, week1.menu.product_name, 
	 case when order_date between join_date and DATEADD(day,7,join_date)
	 then price*20
	 when order_date < join_date
	 then null
	 else
	 case when product_name='sushi' then (price*20)
	 else price*10
	 end
	 end points
	 from week1.sales
	 inner join week1.menu on week1.menu.product_id=week1.sales.product_id
	 inner join week1.members on week1.members.customer_id=week1.sales.customer_id
	 )
	 select customer_id, SUM(points) sum_of_points from ctepoints
	 where ctepoints.order_date between '2021-01-01' and '2021-01-31'
	 group by customer_id