select count(*) from movies;
select count(*) from tags;

-- 1.一共有多少不同的用户--
select count(*) from (
select userID from tags 
union 
select userId from ratings) as a;

-- 2.一共有多少不同的电影--
select count(distinct movieId) from movies;

-- 3.一共有多少不同的电影种类--
select count(distinct gen) from (
SELECT  SUBSTRING_INDEX(SUBSTRING_INDEX(movies.genres,'|',helpTopic.help_topic_id+1),'|',-1) as gen FROM movies
left join mysql.help_topic helpTopic
on helpTopic.help_topic_id < (LENGTH(movies.genres)-LENGTH(REPLACE(movies.genres,'|',''))+1)) as a;

-- 4.一共有多少电影没有外部链接--
select count(distinct movieId) from movies
where movieId not in 
(select movieId from links);

-- 5.2018年一共有多少人进行过电影评分--
select unix_timestamp('2018-01-01 00:00:00');
select unix_timestamp('2019-01-01 00:00:00');

select count(distinct userId) from ratings
where timestamp >= 1514736000 and timestamp < 1546272000;

-- 6.2018年评分5分以上的电影及其对应的标签--
select a.movieId,a.title,b.avg_rat,c.tag 
from movies as a left join 
(select movieId,avg(rating) as avg_rat from ratings
where timestamp >= 1514736000 and  timestamp < 1546272000 
group by movieId having avg(rating)>=5)as b
on a.movieId = b.movieId
left join tags as c
on a.movieId = c.movieId
where
c.timestamp >= 1514736000 and  c.timestamp < 1546272000;
