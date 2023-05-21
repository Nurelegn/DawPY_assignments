
----Create a scalar-valued function that returns the factorial of a number you gave it.
with fact_func (num, factorial) as (
  select 0 as num, 1 as factorial
  union all
  select fact_func.num + 1 as num, fact_func.factorial * (fact_func.num + 1) from fact_func 
    where fact_func.num < 5 
)
select factorial from fact_func where num = 5; 