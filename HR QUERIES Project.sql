create database HR_Project;
use HR_Project;

select * from hr;

alter table hr
modify column birthdate date;

alter table hr
modify column birthdate date;

select birthdate from hr;

select hire_date from hr;

set sql_safe_updates = 0;

UPDATE hr
SET birthdate = CASE
  WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
  ELSE NULL
 END; 
 
UPDATE hr
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
  ELSE NULL
 END; 
 
 update hr
 set termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
 where termdate is not null and termdate != '';
 
 select termdate from hr;
 
ALTER TABLE hr
MODIFY COLUMN termdate DATE;
 
 alter table hr
 modify column hire_date date;

desc hr;

alter table hr
change column ï»¿id emp_id varchar(20) null;

alter table hr
add column age int;

select birthdate, age from hr;

select max(age), min(age) from hr;

update hr
set age = timestampdiff(Year, birthdate, curdate());

select gender, birthdate, current_date()- birthdate as p_age from hr;

select count(*) from hr where age< 18;

use hr_project;

--- QUESTIONS

##1. what is the gender breakdown of employees in the company?

select gender, count(*) as count
from hr
where age>=18 and termdate= ''
group by gender;

select max(age), min(age) from hr;


## 2. what is the race/ethnicity breakdown of employees in the company?

select race, count(*) as count
from hr
where age>=18 and termdate = ''
group by race
order by count(*) desc;

use hr_project;

## 3. what is the age distribution of employees in the company?
select min(age) youngest, max(age) Oldest from hr
where age>=18 and termdate='';

select
 case 
 when age >=18 and age<=24 then '18-24'
 when age >=25 and age<=34 then '25-34'
 when age >=35 and age<=44 then '35-44'
 when age >=44 and age<=54 then '44-54'
 when age >=55 and age<=64 then '55-64'
 else '65+'
 end as age_cat,
 count(*) as Count
 from hr
 where age>=18 and termdate = ''
 group by age_cat
 order by age_cat;
use  hr_project;

 select
 case 
 when age >=18 and age<=24 then '18-24'
 when age >=25 and age<=34 then '25-34'
 when age >=35 and age<=44 then '35-44'
 when age >=44 and age<=54 then '44-54'
 when age >=55 and age<=64 then '55-64'
 else '65+'
 end as age_cat,  gender,
 count(*) as Count
 from hr
 where age>=18 and termdate = ''
 group by age_cat,  gender
 order by age_cat,  gender;
 
 select
 case 
 when age >=18 and age<=24 then 'Young_Youths'
 when age >=25 and age<=34 then 'Youths'
 when age >=35 and age<=44 then 'Young_Adults'
 when age >=44 and age<=54 then 'Adults'
 when age >=55 and age<=64 then 'Young_Elderly'
 else 'Elderly'
 end as age_categories,  gender,
 count(*) as Count
 from hr
 where age>=18 and termdate = ''
 group by age_categories,  gender
 order by age_categories,  gender;
 
 select first_name, last_name, department, emp_id, count(emp_id) over(partition by department order by last_name asc) from hr;
 
 select first_name, last_name, department, emp_id, row_number() over(partition by emp_id ), rank() over(partition by emp_id ),
 dense_rank() over(partition by emp_id)from hr;
 
 -- 4. how many employees work at headquarters versus remote locations?
 select location, count(*) as count
 from hr
 where age>=18 and termdate = ''
 group by location;
 
 ##5. what is the average length of employment for employees who have been terminated?
 
 select 
avg(datediff(termdate, hire_date))/365 as avg_length_employment
 from hr
 where termdate <= curdate() and termdate <> '' and age>=18;
 
 -- 6. how does the gender distribution vary across department and job titles?
 select department, gender, count(*) as count
 from hr
 where age>=18 and termdate=''
 group by department, gender
 order by department;
 
 -- 7. what is the distribution of job titles across the company?
 select jobtitle, count(*) as count
 from hr
 where age >=18 and termdate=''
 group by jobtitle
 order by jobtitle desc;
 
 -- 8. which department has the highest turnover rate?
 select department,
 total_count,
 terminated_count,
 terminated_count/total_count as termination_rate
 from (
   select department,
   count(*) as total_count,
   sum(case when termdate <> '' and termdate <= curdate() then 1 else 0 end) as terminated_count
   from hr
   where age>=18
   Group by department
   ) as subquery
   order by termination_rate desc;
   
   -- 9. what is the distribution of employees across locations by city and state?
   
   select location_state, count(*) as count
   from hr
   where age>=18 and termdate = ''
   group by location_state
   order by count desc;
   
   -- 10. how has the company's employee count changed over time based on hire and term dates?
  select
  year, 
  hires,
  terminations,
  hires - terminations as net_change,
  round((hires - terminations)/hires * 100, 2) as net_change_percent
  from(
   select year(hire_date) as year, 
   count(*) as hires,
   sum(case when termdate <>'' and termdate <= curdate() then 1 else 0 end) as terminations
   from hr
   where age>18
   group by year(hire_date)
   ) as subquery
   order by year;
 
 -- 11. what is the tenure distribution for each department?
 select department, round(avg(datediff(termdate, hire_date)/365),0) as avg_tenure
 from hr
where termdate<= curdate() and termdate<>'' and age>=18
group by department;

 