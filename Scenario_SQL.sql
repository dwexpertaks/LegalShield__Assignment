Based on the data model the scenario based SQL questions answered in following ways - 


Which movie had the highest rating per country and year?
select * from
(select
  dm.title,
  dm.country,
  dm.year,
  fmr.weighted_average_vote,
  dense_rank() over(partition by dm.country, dm.year order by fmr.weighted_average_vote desc) as rnk
from
  fact_movie_rating fmr,
  dim_movie dm
where
  dm.dw_movie_id = fmr.dw_movie_id)
where rnk = 1;



What are the average ages of the actors for each movie?
select
  title,
  trunc(avg_month/12) year,
  trunc(mod(avg_month,12)) month,
  mod(avg_month,12)/30 days
from (
 select
  dm.dw_movie_id,
  dm.title,
  avg(datediff(month, dp.date_of_birth, current_date)) as avg_month
 from
  bridge_movie_person bmp,
  dim_movie dm,
  dim_person dp
 where
  b.dw_movie_id = m.dw_movie_id
 and
  b.dw_person_id = m.dw_person_id
 and
  b.categpry = 'actor'
 group by
  m.dw_movie_id, title);
