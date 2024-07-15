---TABLES 
select * from order_details
select * from pizza_types
select * from pizzas
select * from orders

---Retrieve the total number of orders placed
select count(order_id) as total_orders from orders 

---Calculate the total revenue generated from pizza sales.
select * from order_details
select * from pizzas

select round(sum(order_details.quantity * pizzas.price),2) as total_sales 
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id

---Identify the highest-priced pizza.
select * from pizza_types 
select * from pizzas

select top 1 pizza_types.name , pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc

---Identify the most common pizza size ordered.
select * from order_details
select * from pizzas

select top 1 pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size 
order by order_count desc

--list the top5 most ordered pizza type 
---along with their quantity 
select * from pizza_types
select * from order_details 
select * from pizzas

select top 5 pizza_types.name , count (order_details.quantity) as quantity_order
from pizza_types join pizzas
on pizza_types.pizza_type_id =pizzas.pizza_type_id
join order_details
on order_details.pizza_id=  pizzas.pizza_id
group by pizza_types.name
order by quantity_order desc




---intermedatory
---join the neccesary tables to find total quantity of each pizza category ordered

select pizza_types.category,sum(order_details.quantity) as quantity_ordered
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by quantity_ordered desc 

---determine the distribution of orders by hours of the day

SELECT DATEPART(hour, time) AS order_hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY DATEPART(hour, time)
ORDER BY order_hour ASC;

---Join relevant tables to find the category-wise distribution of pizzas.

select * from pizza_types

select category, count(name) as distr
FROM pizza_types
group by category
order by distr desc

---Group the orders by date and calculate the average number of pizzas ordered per day.
select * from orders 
select * from order_details

select round(avg(quantity),0) as avg_pizzas_ordered_prday
from
(select orders.date ,sum (order_details.quantity) as quantity
from orders join order_details
on orders.order_id= order_details.order_id
group by orders.date) 
as ordered_quantity 

---Determine the top 3 most ordered pizza types based on revenue.
select * from order_details
select * from pizzas
select * from pizza_types

select top 3 pizza_types.name ,sum( pizzas.price* order_details.quantity) as revenue
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by revenue desc



---advance
---Analyze the cumulative revenue generated over time.

select date,sum(revenue)over (order by date ) as cum_revenue from
(select orders.date, sum (order_details.quantity*pizzas.price ) as revenue
from order_details join orders 
on order_details.order_id=orders.order_id
join pizzas
on pizzas.pizza_id=order_details.pizza_id
group by orders.date) as acc_sales 

---Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select top 3 name, revenue
from
(select category,name,revenue , rank() over(partition by category order by revenue desc) as rank_
from
(select pizza_types.category ,pizza_types.name,
sum(order_details.quantity* pizzas.price) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id= pizzas.pizza_id
group by pizza_types.category ,pizza_types.name) as a) as b
where rank_<=3












































