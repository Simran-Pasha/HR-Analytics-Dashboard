create database HR_Analytics;
use HR_Analytics;

#How many employees are there in the company?
select count(*) as Total_employees from employees;

#"How many employees are there in each department?"
select Department, count(*) as Emp_Count 
from employees
group by Department;

#"Find the average salary of each department."
select Department, avg(`Annual Salary Numeric`) as avg_salary 
from employees 
group by Department;

Select * from employees;
#"Show the average salary of employees who work in the IT department."
select Department, avg(`Annual Salary Numeric`) as avg_salary 
from employees 
where department = "IT";
 show columns from employees ;
 
 SELECT `Annual Salary (INR)`
FROM employees
LIMIT 5;

#"Show departments where the average salary is greater than ₹10,00,000."
select Department, avg(`Annual Salary Numeric`) as avg_salary 
from employees 
group by Department
having avg_salary  > 1000000;

#Show the Top 5 highest-paid employees in the company.
select `Employee Name`, `Annual Salary Numeric` 
from employees
order by `Annual Salary Numeric` desc
limit 5;


#"Don't show the exact salary. Categorize employees as High, Medium, or Low salary."
select `Annual Salary Numeric`, `Employee Name`,
case
when `Annual Salary Numeric` >= 1500000 then "High Salary"
when `Annual Salary Numeric` >= 800000 then "Meduim Salary"
else "Low Salary" 
end as Salary_Category
from employees;

#Categorize employees based on Performance Rating.
select `Employee Name`, `Performance Rating`,
case 
when `Performance Rating` >= 5 then "Excellent"
when `Performance Rating` >= 4 then "Good"
else "Needs Improvement" 
end as "Performance Category"
from employees;

#Categorize employees based on Attendance %.
select `Employee Name`, `Attendance %` ,
case 
when `Attendance %` between 95 and 100 then "Excellent"
when `Attendance %` between 85 and 94 then "Good" 
else "Poor"
end as emp_attendace
from employees;

show columns from employees;

describe employees;
ALTER TABLE employees
CHANGE COLUMN `ï»¿Employee ID` `Employee ID` TEXT;

create table employee_master as
select 
`Employee ID`,
`Employee Name`,
Department,
`Manager Name`,
`Joining Date`
from employees;

CREATE TABLE salary AS
SELECT
    `Employee ID`,
    `Annual Salary Numeric`
FROM employees;

CREATE TABLE performance AS
SELECT
    `Employee ID`,
    `Performance Rating`,
    `Attendance %`,
    Attrition
FROM employees;

#"Show Employee Name and Annual Salary."
select em.`Employee Name`, 
       s. `Annual Salary Numeric`
       from employee_master em inner join 
       salary s on
       em.  `Employee ID`= s.  `Employee ID`;
       
      # "Show Employee Name, Annual Salary, Performance Rating and Attendance %."
       select em.`Employee ID`,
       em.`Employee Name`,
       s.`Annual Salary Numeric`,
       p. `Performance Rating`,
       p.`Attendance %` 
       from employee_master em inner join salary s 
       on em.`Employee ID` = s.`Employee ID`
       inner join performance p
       on  em.`Employee ID` = p.`Employee ID`;
       
       #"List all employees who have not yet received a salary record."
       select em.`Employee ID`,
              em.`Employee Name`
              from employee_master em left join salary s
              on em.`Employee ID` = s.`Employee ID`
              where s.`Annual Salary Numeric` is null;
       
#"Show all salary records, even if an employee record is missing."
select em.`Employee ID`,
              em.`Employee Name`
              from employee_master em right join salary s
              on em.`Employee ID` = s.`Employee ID`
              where em.`Employee Name` is null;
              
              DELETE FROM salary
WHERE `Employee ID` = 'EMP0005';


#"I want the salary rank of EVERY employee."
select `Employee Name`, `Annual Salary Numeric`,
rank() over (PARTITION BY Department order by `Annual Salary Numeric` desc) as Salary_rank 
from employees;

#"Rank employees based on Performance Rating from highest to lowest."
select `Employee Name`, `Performance Rating`, 
rank() over(order by `Performance Rating` desc) as performance_rank 
from employees;

select `Employee Name`, `Annual Salary Numeric`,
dense_rank() over (order by `Annual Salary Numeric` desc) as Salary_rank 
from employees;
select `Employee Name`, `Annual Salary Numeric`,
row_number() over (order by `Annual Salary Numeric` desc) as Salary_rank 
from employees;

#Rank employees within each department based on salary.
select `Employee Name`, `Annual Salary Numeric`, Department ,
row_number () over (partition by Department order by `Annual Salary Numeric` desc)
as dept_rank  from employees;

#"Assign a dense rank to employees within each department based on Annual Salary Numeric."
select `Employee Name`, `Annual Salary Numeric`, Department,
dense_rank() over(partition by department order by `Annual Salary Numeric` desc) as dens_rank 
from employees;


#Find the Top 2 employees in each department based on Performance Rating.
with rating as 
(
select `Employee ID`, `Employee Name`, Department, `Performance Rating`,
row_number() over (partition by Department order by `Performance Rating` desc) as performance_rating from employees
)
select * from  rating
where performance_rating <= 2;

#Show Employee Name, Performance Rating and the previous employee's Performance Rating (ordered by Performance Rating DESC).
select `Employee ID`,`Employee Name`, `Performance Rating`, 
lag(`Performance Rating`) over (order by `Performance Rating`desc) as per_perf_rank from employees;
 
 #Show Employee ID, Employee Name, Performance Rating, and the next employee's Performance Rating (ordered by Performance Rating DESC).


#Find employees whose Performance Rating is greater than the average Performance Rating of all employees.
select `Employee Name`, `Performance Rating`
from employees where `Performance Rating` >
(
select avg(`Performance Rating`) from employees);