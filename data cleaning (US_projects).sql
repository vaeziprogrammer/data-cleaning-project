 # US Houshold income data cleaning

SELECT *
FROM US_project.houseUS;

SELECT *
FROM UHI;

SELECT count(id)
FROM houseUS;

SELECT COUNT(id)
FROM UHI;

SELECT id, COUNT(id)
FROM houseUS
GROUP BY id
HAVING COUNT(id) > 1 ; 

select *
from (
select row_id, id, row_number() over(partition by id order by id) row_num
from houseus
) duplicates
where row_num > 1
;

# turend out that we have 6 row_id that they are duplicates, so now we need to remove them

select row_id
from (
select row_id, id, row_number() over(partition by id order by id) row_num
from houseus
) duplicates
where row_num > 1
;

-- let's delete them


delete from houseus
where row_id in (
	select row_id
	from (
		select row_id, id, row_number() over(partition by id order by id) row_num
		from houseus
		) duplicates
	where row_num > 1)
;

select distinct state_name
from houseus
order by 1
;

# we wanted to see the correct spelling format and we found 'georia' and 'alabama' let's correct it:
update houseus
set state_name ='Georgia'
where state_name = 'georia';

update houseus
set state_name ='Alabama'
where State_name = 'alabama';

# let's see the missing value in our database 

select *
from houseus
where place =''
order by 1
;

# we did this code above, but apparently this column set to null and we are gonna chage it to =''

UPDATE houseus
SET place = ''
WHERE place IS NULL;
 
 
----
update houseus
set place = 'Autaugaville' 
where row_id = 32;

select *
from houseus
where row_id = 32;

# now this missing value is fixed

select type, count(type)
from houseus
group by type; -- it turned out we have two similar together which are CDP and CPD. as the majority is set to CDP, we are gonna update it to: 


update houseus
set type = 'CDP'
where type ='CPD'
;

---
# let's see do we have any missing data in Aland and Awater columns or not

select aland, awater
from houseus
where (awater = 0 or awater = '' or awater is null)
and (aland = 0 or aland = '' or aland is null)
;

# we don't have any missing values, that's it
# data cleaning is done in this phase. 




