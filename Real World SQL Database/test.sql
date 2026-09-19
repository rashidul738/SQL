SELECT DISTINCT a.city ->> 'en' as city
FROM airports a
WHERE a.city ->> 'en' <> 'Moscow'
ORDER BY city;


SELECT * FROM airports

---List the cities in which there is no flights from Moscow ?
SELECT DISTINCT city ->> 'en' AS city
FROM airports
WHERE city ->> 'en' <> 'Moscow'
ORDER BY city;

---Select airports in a time zone is in Asia / Novokuznetsk and Asia / Krasnoyarsk ?
SELECT timezone 
FROM airports
WHERE timezone IN ('Asia/Novokuznetsk', 'Asia/Krasnoyarsk');

---Which planes have a flight range in the range from 3,000 km to 6,000 km ?
SELECT range 
FROM aircrafts
WHERE range BETWEEN 3000 AND 6000;

---Get the model , range,  and miles of every air craft exist in the Airlines database, notice that miles = range / 1.609  and round the result to 2 numbers after the float point?
SELECT 
    model ->> 'en' AS Model, 
    range, 
    ROUND((range/1.609),2) AS miles
FROM aircrafts

---- Return all information about air craft that has aircraft_code = 'SU9' and its range in miles ?

SELECT 
    aircraft_code,
    model ->> 'en' AS Model,
    ROUND((range/1.609),2) AS miles
FROM aircrafts
WHERE aircraft_code = 'SU9';


---Calculate the Average tickets Sales?

SELECT 
    ROUND(AVG(amount), 2) AS avg_ticket_price 
FROM ticket_flights;

--Return the number of seats in the air craft that has aircraft code = 'CN1' ?

SELECT COUNT(seat_no) AS Number_of_Seats
FROM seats
WHERE aircraft_code = 'CN1';
-- GROUP BY aircraft_code
-- HAVING aircraft_code = 'CN1';


---Return the number of seats in the air craft that has aircraft code = 'SU9'  ?
SELECT aircraft_code, COUNT(seat_no) AS Number_of_Seats
FROM seats
GROUP BY aircraft_code
HAVING aircraft_code = 'SU9';

--- Write a query to return the aircraft_code and the number of seats of each air craft ordered ascending?

SELECT aircraft_code, COUNT(seat_no) AS Number_of_Seats
FROM seats
GROUP BY aircraft_code
ORDER BY aircraft_code ASC;

--calculate the number of seats in the salons for all aircraft models, but now taking into account the class of service Business class and Economic class.

SELECT COUNT(seat_no) AS number_of_seat, fare_conditions
FROM seats
GROUP BY fare_conditions
HAVING fare_conditions IN ('Business', 'Economy');


--What was the least day in tickets sales?

SELECT book_date, SUM(total_amount) AS totalSales
FROM bookings
GROUP BY book_date
ORDER BY totalSales ASC
LIMIT 1;


--Another solution:
SELECT min (total_amount)
FROM bookings;


---Determine how many flights from each city to other cities, return the the name of city and count of flights more than 50 order the data from the largest no of flights to the least?
SELECT(
    SELECT city ->> 'en' FROM airports
    WHERE airport_code = departure_airport
) AS departure_city, 
COUNT(*)
FROM flights
GROUP BY (
    SELECT city ->> 'en' FROM airports
    WHERE airport_code = departure_airport
)
HAVING COUNT(*) >= 50
ORDER BY count DESC;

SELECT (SELECT city ->> 'en' FROM airports WHERE airport_code =departure_airport) AS departure_city, COUNT(*)
FROM flights
GROUP BY (SELECT city ->> 'en' FROM airports WHERE airport_code =departure_airport)
HAVING count (*)>= 50
ORDER BY Count DESC;



SELECT * FROM airports

---Return all flight details in the indicated day 2017-08-28
--include flight count ascending order and departures count and when departures happen in arrivals count and when arrivals happen?
SELECT * FROM flights

SELECT
    flight_no,
    scheduled_departure :: TIME AS dep_time,
    departure_airport AS departure,
    arrival_airport AS arrival,
    COUNT(flight_id) AS flight_count
FROM flights
GROUP BY flight_no, scheduled_departure, arrival_airport, departure_airport
HAVING scheduled_departure >= '2017-08-28' :: DATE
AND scheduled_departure >= '2017-08-29' :: DATE


SELECT
    flight_no,
    scheduled_departure :: TIME AS dep_time,
    departure_airport,
    scheduled_arrival :: TIME AS arr_time,
    arrival_airport,
    COUNT(flight_no) AS flight_count
FROM flights
WHERE DATE(scheduled_departure) = '2017-08-28'
GROUP BY flight_no, scheduled_departure, departure_airport, scheduled_arrival, arrival_airport
ORDER BY flight_count ASC;


SELECT
    COUNT(NULLIF(actual_departure, null)) AS NullDeparture,
    COUNT(NULLIF(actual_arrival, null)) AS NullArrival
FROM flights


----non null value count
SELECT
    COUNT(*) - COUNT(NULLIF(actual_departure, null)) AS Non_NullDeparture,
    COUNT(*) - COUNT(NULLIF(actual_arrival, null)) AS Non_NullArrival
FROM flights


SELECT * FROM flights

SELECT
    status,
    COALESCE(actual_departure, current_timestamp) AS actual_departure,
    COALESCE(actual_arrival, CURRENT_TIMESTAMP) AS actual_arrival
FROM flights
WHERE actual_departure ISNULL or actual_arrival ISNULL;

SELECT * FROM aircrafts

---- write a query to arrange the range of model of air crafts so  Short range is less than 2000, Middle range is more than 2000 and less than 5000 & any range above 5000 is long range?

SELECT  
    model ->> 'en',
    range,
    CASE 
        WHEN range < 2000 THEN 'Short' 
        WHEN range > 2000 AND range < 5000 THEN 'Middle' 
        ELSE  'Long'
    END AS range_category
FROM aircrafts


--What is the shortest flight duration for each possible flight from Moscow to St. Petersburg, and how many times was the flight delayed for more than an hour?
SELECT
    flight_no,
    (scheduled_arrival - scheduled_departure) AS schedule_duration,
    MIN(scheduled_arrival - scheduled_departure) AS Min_duration,
    MAX(scheduled_arrival - scheduled_departure) AS Max_durations,
    SUM(CASE WHEN actual_departure > scheduled_departure + INTERVAL '1 hour' THEN  1 ELSE  0 END) AS Delays
FROM flights 
WHERE (SELECT city ->> 'en' FROM airports WHERE airport_code = departure_airport) = 'Moscow'
AND (SELECT city ->> 'en' FROM airports WHERE airport_code = arrival_airport) = 'St. Petersburg'
AND status = 'Arrived'
GROUP BY flight_no, (scheduled_arrival - scheduled_departure);

---
SELECT 
    EXTRACT('day' FROM book_date) AS day,
    EXTRACT('month' FROM book_date) AS month,
    EXTRACT('year' FROM book_date) AS year,
    SUM(total_amount) AS Sales
FROM bookings
GROUP BY 1,2,3
ORDER BY 1, 2, 4;

---date_trunc
SELECT
    book_date,
    DATE_TRUNC('day', book_date) AS day,
    COUNT(total_amount) AS booking_amount
FROM bookings
GROUP BY date_trunc('day', book_date)
ORDER BY booking_amount DESC;


-------Date part
SELECT
    DATE_PART('day', book_date) AS day,
    DATE_PART('month', book_date) AS month,
    DATE_PART('year', book_date) AS year,
    SUM(total_amount) AS total_booking
FROM bookings
GROUP BY day, month, year
HAVING DATE_PART('month', book_date) = 6 and DATE_PART('day', book_date) = 25;


-----What is the maximum booking month

SELECT MAX(total_booking) AS max_month_booking
FROM(
    SELECT
        date_part('month', book_date) AS month,
        SUM(total_amount) AS total_booking
    FROM bookings
    GROUP BY date_part('month', book_date)
);


SELECT
    date_part('month', book_date) AS month,
    SUM(total_amount) AS total_booking
FROM bookings
GROUP BY month
ORDER BY total_booking DESC
LIMIT 1;


----
SELECT book_date, book_ref
FROM bookings
WHERE book_date = '2017/08/13' :: DATE;

SELECT  
    DATE_TRUNC('day', book_date) AS date_trunc,
    date_part('day', book_date) AS date_part,
    EXTRACT('day' FROM book_date) AS extract_date,
    CURRENT_DATE
FROM bookings


SELECT 
    s.seat_no, 
    s.fare_conditions, 
    a.model ->> 'en' AS model,
    f.flight_no,
    f.departure_airport,
    f.arrival_airport,
    f.status
FROM seats s
INNER JOIN aircrafts a
ON s.aircraft_code = a.aircraft_code
INNER JOIN flights f
ON a.aircraft_code = f.aircraft_code
WHERE f.status = 'Cancelled' AND model ->> 'en' LIKE 'Cessna%';


SELECT
    AVG(salary) AS sa

