-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT s.film_title, s.release_year, re.worldwide_gross
FROM specs AS s
INNER JOIN revenue AS re
USING (movie_id)
ORDER BY re.worldwide_gross ASC;

--ANSWER: Semi-Tough, 1977, 37,187,139

-- 2. What year has the highest average imdb rating?

SELECT s.release_year, ROUND(AVG(ra.imdb_rating),2) AS avg_rating
FROM specs AS s
INNER JOIN rating AS ra
USING (movie_id)
GROUP BY s.release_year
ORDER BY avg_rating DESC;

--ANSWER: 1991, 7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT d.company_name, s.film_title, s.mpaa_rating, re.worldwide_gross
FROM distributors AS d
INNER JOIN specs AS s ON d.distributor_id = s.domestic_distributor_id
INNER JOIN revenue AS re USING (movie_id)
WHERE s.mpaa_rating = 'G'
GROUP BY s.film_title, d.company_name, s.mpaa_rating, re.worldwide_gross
ORDER BY re.worldwide_gross DESC;

--ANSWER: Walt Disney, Toy Story 4, 1,073,394,593

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT d.company_name, COUNT(s.film_title) AS title_count
FROM distributors AS d
LEFT JOIN specs AS s
ON d.distributor_id = s.domestic_distributor_id
GROUP BY d.company_name;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT d.company_name, ROUND(AVG(re.film_budget),2) AS avg_budget
FROM distributors AS d
INNER JOIN specs AS s ON d.distributor_id = s.domestic_distributor_id
INNER JOIN revenue AS re USING (movie_id)
GROUP BY d.company_name
ORDER BY avg_budget DESC
LIMIT 5;

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT d.company_name, s.film_title, ra.imdb_rating
FROM distributors AS d 
INNER JOIN specs AS s ON d.distributor_id = s.domestic_distributor_id
INNER JOIN rating AS ra USING (movie_id)
WHERE d.headquarters NOT LIKE '%CA%'
GROUP BY d.company_name, s.film_title, ra.imdb_rating;

--ANSWER: Dirty Dancing

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT avg(ra.imdb_rating)
FROM specs AS s
INNER JOIN rating AS ra
USING (movie_id)
WHERE s.length_in_min > '120'

UNION

SELECT avg(ra.imdb_rating)
FROM specs AS s
INNER JOIN rating AS ra
USING (movie_id)
WHERE s.length_in_min <= '120'

