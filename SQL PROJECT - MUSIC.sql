1-who is the senior most employee based on job title?
--here use levels instead of title.
SELECT * FROM employee
order by title desc 
limit 1;

2-which countries have the most invoices?

select count(*) as c, billing_country
from invoice
group by billing_country
order by c desc;

3-what are the top 3 values of total invoices?

select * from invoice 
order by total desc
limit 3;

4-which city has the best customers?
we would like to throw a promotional music festival in the city we made most money. 
Write a query that returns one city that has the highest sum of invoices total.
Return both the city name and sum of all invoices?

select sum(total) as invoice_total , billing_city
from invoice
group by billing_city
order by invoice_total desc 

5- who is the best customer?
the customer who has the spend the most money will be declared the best customer.
write a query that returns the person who has spend the most money?

select  customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total from customer 
join invoice  on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1 

--6-write query to return the email,first name,last name & genre of all rock music listeners. 
--return your list order alphabetically by email starting with A. 

select email, first_name , last_name from customer
join invoice on customer. customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
          select track_id from track
		  join genre on track.genre_id = genre.genre_id
		  where genre.name like 'Rock')
order by email;

--7.lets invite the artists who have written the most rock music in our dataset.
--write a query that returns the artist name & total track count of the top 10 rock bands.

select artist.artist_id , artist.name , count(artist.artist_id) as number_of_songs 
from track
join album on track.album_id = album.album_id
join artist on album.artist_id = artist.artist_id
join genre on track.genre_id = genre.genre_id
where genre.name like ('Rock')
group by artist.artist_id
order by number_of_songs desc
limit 10;


--8.return all the track names that have a song length longer than the average song length.
--return the name and milliseconds for each track.
--order by the song length with the longest songs listed first.

select name , milliseconds  
from track
where milliseconds > 
          (select avg (milliseconds) as avg_track_length
		   from track)
order by milliseconds desc

--9.find how much amount spend by each customer on artists?
--write a query to return customer name,artist name and total spend.
--first find one artist to earn high and then each customer to spent on that artist.


with best_selling_artist as (
	SELECT artist.artist_id as artist_id,artist.name as artist_name, sum(invoice_line.unit_price * invoice_line.quantity) as most_earn_amount
	FROM invoice_line
	join track on track.track_id = invoice_line.track_id
	join album on track.album_id =album. album_id 
	join artist on artist.artist_id = album.artist_id
	group by 1
	order by 3 desc
	limit 1
)

select c.customer_id, c.first_name,last_name, bsa.artist_name,sum(il.unit_price*il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc; 

10.--we want to find out the most popular music genre for each country . 
--we determine the most popular genre as the genre with the highest amount of purchasees.
--write a query that returns each country along with the top genre.
--for countries where the maximum number of purchases is shared return all genres.

with popular_genre as (
	select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
	row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as rowno
	from invoice_line
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by 2,3,4
	order by 2 asc , 1 desc
	)

select * from popular_genre where rowno <=1 


11.--write a query that dertermines the customer that has spent the most on music for each country .
--write a query that returns the country along with top customer and how much they spent.
--for countries where the top amount spent is shared, provide all customers who spent this amount.

with customer_with_country as (

	select customer.customer_id,first_name,last_name,billing_country,sum(total) as total_spending,
row_number() over (partition by billing_country order by sum(total) desc) as rowno
	from invoice
	join customer on customer.customer_id = invoice.customer_id
	group by 1,2,3,4
	order by 4 asc, 5 desc 
	)

select * from customer_with_country where rowno <= 1





















       
       
