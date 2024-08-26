------ NAMMA YATRI CUSTOMER JOUNERY ANALYTICS--

select * from trips;

select * from trips_details;

select * from duration;

select * from assembly;

select * from payment;

------------
--total trips

select count(distinct tripid) from trips_details;


--total drivers

select * from trips;

select count(distinct driverid) from trips;

-- total earnings

select sum(fare) from trips;

-- total Completed trips

select * from trips_details;

select sum(end_ride) from trips_details;

--total searches

select sum(searches) total_searches,sum(searches_got_estimate) search_estm,sum(searches_for_quotes) search_for_quote,sum(searches_got_quotes) search_got_quote,
sum(customer_not_cancelled) cust_not_cancelled,sum(driver_not_cancelled) driver_not_cancelled,sum(otp_entered) otp_entered,sum(end_ride) end_ride
from trips_details;

--total searches which got estimate
select SUM(searches_got_estimate) searches from trips_details;

--total searches for quotes
select SUM(searches_for_quotes) searches from trips_details;

--total searches which got quotes
select SUM(searches_got_quotes) searches from trips_details;


select * from trips;


select * from trips_details;


--total driver cancelled
select COUNT(*) - SUM(driver_not_cancelled) driver_cancelled from trips_details;


--total otp entered

select SUM(otp_entered) searches from trips_details;

--total end ride
select SUM(end_ride) searches from trips_details;


--cancelled bookings by driver
select SUM(searches) - SUM(driver_not_cancelled) cancelled_by_driver from trips_details

--cancelled bookings by customer
select SUM(searches) - SUM(customer_not_cancelled) cancelled_by_driver from trips_details


--average distance per trip

select AVG(distance) from trips;



--average fare per trip

select sum(fare)/count(*) from trips;

--distance travelled

-- which is the most used payment method 
   
select p.method from payment p inner join
(
select top 1 faremethod,COUNT(faremethod) cnt from trips
group by  faremethod
order by COUNT(distinct tripid) desc) b
on	p.id = b.faremethod;


-- the highest payment was made through which instrument

select p.method from payment p inner join
(
select top 1 * from trips
order by fare desc ) b
on	p.id = b.faremethod;

-- which two locations had the most trips

select * from
(select *,dense_rank()over(order  by trip desc) rnk
from
(select loc_from,loc_to,COUNT(distinct tripid) trip from trips
group by loc_from,loc_to
)a)b
where rnk = 1;


--top 5 earning drivers

select * from
(select *, dense_rank() over(order by fare desc) rnk
from
(select driverid,SUM(fare)fare from trips
group by driverid)b)c
where rnk < 6;

-- which duration had more trips


select * from
(select *,RANK() over(order by cnt desc) rnk from
(select duration,COUNT(distinct tripid) cnt from trips
group by duration)b)c
where rnk = 1;

-- which driver , customer pair had more orders

select * from
(select * ,rank() over(order by cnt desc) rnk from
(select driverid,custid, COUNT(distinct tripid) cnt from trips
group by driverid,custid)c)d
where rnk = 1;

-- search to estimate ratee /
select SUM(searches_got_estimate)*100/SUM(searches) estm_rate  from trips_details

-- estimate to search for quote rates
select SUM(searches_for_quotes)*100/SUM(searches) search_quote_rate  from trips_details

select * from trips_details;

-- quote acceptance rate
select SUM(searches_got_quotes)*100/SUM(searches) search_quote_rate  from trips_details


-- quote to booking rate

select SUM(searches_for_quotes)*100/SUM(searches) search_quote_rate  from trips_details



-- booking cancellation rate
select   (SUM(searches) - SUM(customer_not_cancelled))*100/SUM(searches) from trips_details;


-- conversion rate

select SUM(end_ride)*100/SUM(searches) from trips_details;


-- which area got highest trips in which duration

select * from 
(select *,rank() over(partition by duration order by cnt desc) rnk from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)a)c
where rnk = 1;

-- which duartion got the highesr number of trip in each location present
select * from 
(select *,rank() over(partition by loc_from order by cnt desc) rnk from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)a)c
where rnk = 1;


-- which area got the highest fares, cancellations,trips,

select * from
(select *,rank() over(order by fare desc) rnk from
(select loc_from,SUM(fare) fare from trips
group by loc_from)b)c
where rnk =1;

select * from
(select *,RANK() over(order by can desc) rnk from
(select loc_from,COUNT(*) - SUM(driver_not_cancelled) can
from trips_details
group by loc_from)b)c
where rnk=1;


select * from
(select *,RANK() over(order by can desc) rnk from
(select loc_from,COUNT(*) - SUM(customer_not_cancelled) can
from trips_details
group by loc_from)b)c
where rnk=1;


-- which duration got the highest trips and fares

select * from
(select *,rank() over(order by fare desc) rnk from
(select duration,COUNT(distinct tripid) fare from trips
group by duration)b)c
where rnk =1;