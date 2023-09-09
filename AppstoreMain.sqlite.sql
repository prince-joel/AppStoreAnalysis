create table applestore_description_combined AS
SELECT * from appleStore_description1
UNION ALL
SELECT * from appleStore_description2
UNION All 
select * from appleStore_description3
union ALL
select *from appleStore_description4

**Exploratory Data Analysis**
-- Check the count of ID in both tables
select count (Distinct id) as UniqueAppstoreID
from AppleStore;

select count (Distinct id) as UniqueAppstoreID
from applestore_description_combined;

--check for missing data
SELECT count(*) as missingValue
FROM AppleStore
where track_name is null or user_rating is null or prime_genre is null

SELECT count(*) as missingValue
FROM applestore_description_combined
where app_desc is NULL;

-- number of apps per genreAppleStore
SELECT prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

--Overview of apps rating

SELECT min(user_rating) as Min_Rating,
	max(user_rating) as Max_Rating,
    Avg(user_rating) as Avg_Rating
from AppleStore

** Data Analysis**
--Determine if paid apps have more ratings than free apps 
select CASE 
		WHEN price > 0 then "Paid"
        else "Free" 
        end as app_type,
        avg(user_rating) as AVG_Rating
From AppleStore
        group by app_type

--Determine if app that support multiple languages have more ratingsAppleStore
select CASE 
		WHEN lang_num < 10 then "< 10 Lang"
        when lang_num BETWEEN 10 and 30 then "10-30 lang"
        else "> 10 lang" 
        end as App_Lang,
        avg(user_rating) as AVG_Rating
From AppleStore
        group by App_Lang
        ORDER by AVG_Rating DESC


--Genre with low ratings
select prime_genre,
        avg(user_rating) as AVG_Rating
        from AppleStore
        GROUP by prime_genre
          ORDER by AVG_Rating ASC
          limit 10
          
          
-- check if there is a corelation between app description and user rating
SELECT case
	when length(b.app_desc) < 500 then "Short"
    When length(b.app_desc) between 500 and 1000 then "Medium" 
    Else "Long"
    end as desc_length_bucket,
    avg(user_rating) as AVG_Rating
	from 
    AppleStore as A 
    Join 
    applestore_description_combined as B
    on 
    A.id = B.id
    GROUP by desc_length_bucket
    order by AVG_Rating
          
          
--check top rated apps by genre
SELECT
prime_genre,track_name,user_rating 
from (
  SELECT
  prime_genre,track_name,user_rating,
  rank() over(partition by prime_genre ORDER by user_rating DESC, rating_count_tot desc) as RANK
  FROM
  AppleStore
) as A 
where 
A.Rank = 1
          
