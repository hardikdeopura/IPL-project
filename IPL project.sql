create table deliveries (
 match_id int8 ,
 season int8 ,
 start_date date ,
 innings numeric ,
	batting_team varchar(50),
	bowling_team varchar(50),
	over numeric ,
	ball_number numeric ,
	ball decimal , 
	striker char(20), 
	non_striker char(20),
	bowler char(20),
	wide_runs numeric ,
	noball_runs numeric ,
	bye_runs numeric ,
	legbyes_runs numeric ,
	penalty_runs numeric ,
	extra_runs numeric ,
	batsman_runs numeric ,
	player_dismissed char(30),
	dismissal_kind char(20),
	venue varchar(50)
	
)

select * from deliveries ;

create table ipl_2019_2023
( id int8 NOT NUll , 
 match_id int8 PRIMARY KEY , 
 city char(20) , 
 match_date date , 
 season int8 ,
 match_number int8 , 
 team1 varchar(50),
 team2 varchar(50),
 toss_winner varchar(50),
 toss_decision char(10),
 superover char(10),
 result char(20), 
 winning_team varchar(50),
 won_by char(10),
 margin varchar(50),
 winner_runs int8 , 
 winner_wickets int8 , 
 player_of_match char(30),
 venue varchar(50),
 umpire1 char(30),
 umpire2 char(30)

)

select * from ipl_2019_2023 ;

copy IPL_2019_2023(id,match_id,city,match_date,season,match_number,team1,team2,toss_winner,toss_decision,
				   superover,result,winning_team,won_by,margin,winner_runs,winner_wickets,player_of_match,
				   venue,umpire1,umpire2)
				   from 'C:\Actuary\Postgre SQL\SQL projects\IPL project 2019-2023\IPL_2019_2023.csv'
				   delimiter ','
				   csv header ;

alter table ipl_2019_2023
alter column venue type varchar(100) ;

select * from ipl_2019_2023 ;

alter table deliveries
alter column venue type varchar(100) ;

alter table deliveries
alter column dismissal_kind type char(50) ;

copy deliveries(match_id,season,start_date,innings,batting_team,bowling_team,over,ball_number,ball,
							  striker,non_striker,bowler,wide_runs,noball_runs,bye_runs,legbyes_runs,penalty_runs,
							  extra_runs,batsman_runs,player_dismissed,dismissal_kind,venue)
				   from 'C:\Actuary\Postgre SQL\SQL projects\IPL project 2019-2023\deliveries.csv'
				   delimiter ','
				   csv header ;

select * from deliveries ;



--query1 
--WHO ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?

select player_of_match , count(*) as most_POM from ipl_2019_2023 
group by  player_of_match 
order by count(*) desc
limit 5 ;

--query2 
--HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?

select season, winning_team , count(*) as total_matches_won from ipl_2019_2023
group by season , winning_team 
order by season , count(*) desc ;

--query3 
--WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?

select avg(strike_rate) as avg_strike_rate 
from ( select (sum(batsman_runs)/count(ball_number))*100  as strike_rate from deliveries
 );

--query 4
--WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 500 RUNS SCORED)?

select striker , (sum(batsman_runs)/count(ball_number))*100 as strike_rate 
	from deliveries
	group by  striker
    having sum(batsman_runs)>500
    order by strike_rate desc
	limit 1 ;
	
-- query 5
--HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'BUMRAH'?

select player_dismissed , count(player_dismissed) as no_of_dismissals from deliveries 
where player_dismissed is NOT null and bowler='JJ Bumrah' and player_dismissed <> 'run-out'
group by player_dismissed 
order by count(player_dismissed) desc ;
   
				   
--query 6 
--WHAT IS THE TOTAL NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?

select season ,batting_team , fours , sixes, sum(fours+sixes) as total_boundaries
from ( select season , batting_team ,
	 sum(case when batsman_runs =4 then 1 else 0 end) as fours, 
	 sum(case when batsman_runs =6 then 1 else 0 end) as sixes
	  from deliveries
	  group by season , batting_team 
	 order by season , batting_team asc ) as team_boundaries
	 group by season , batting_team ,fours , sixes
	 order by season asc , total_boundaries desc 


--query 7
--HOW MANY EXTRAS WERE BOWLED BY EACH TEAM IN EACH SEASON ? 

select season , bowling_team , sum(extra_runs) as extra_runs
from deliveries
group by season ,bowling_team 
order by season asc ,sum(extra_runs) desc ;



--query 8
--WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?

select round(avg(runs_scored,2) as score from(
select match_id , innings , over , sum(total_runs) as runs_scored
from deliveries 
group by match_id , innings , over ) ;
			 
--query 9
--WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

alter table deliveries 
add column total_runs numeric ;

update deliveries
set total_runs= extra_runs + batsman_runs 

select total_runs , extra_runs,batsman_runs from deliveries;

select match_id , start_date , season ,innings, batting_team , bowling_team , sum(total_runs) as team_score
from deliveries
group by match_id ,start_date, season ,innings ,batting_team , bowling_team  
order by sum(total_runs) desc
limit 5  ;

--query 10
--WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?

select match_id , start_date , season ,innings, batting_team , bowling_team , striker ,
sum(batsman_runs) as runs_scored
from deliveries
group by match_id ,start_date, season ,innings ,batting_team , bowling_team , striker 
order by  sum(batsman_runs) desc 
limit 5;


	   
	   
	  





	  

	 