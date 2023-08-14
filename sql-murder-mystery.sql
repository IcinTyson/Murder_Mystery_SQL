/*We know that the crime was a murder that happened on January 15th, 2018 in SQL city.  
We will look this information up first, but we want to look at the crime report data first.*/

SELECT *
FROM crime_scene_report

/* Now we narrow the information down*/

Select *
From crime_scene_report
WHERE date = '20180115'and type = 'murder' and city = 'SQL City'

/* Now we have information about the two witnesses. First witness lives at the last house
on Northwestern Dr.  The second is named Annabel and lives on Franklin Ave.  We will look 
at the person table*/

SELECT *
FROM person
where address_street_name = 'Northwestern Dr' 
Order by address_number desc 

/* Morty Schapiro is the first witness. ID 14887 license ID 118009.  Now we find the 
second witness*/

SELECT *
FROM person
WHERE name like 'Annab%' and address_street_name = 'Franklin Ave'

/* Annabel Miller is our second witness ID 16371 license id 490173.  Now we can see if they have any information
from the interview table.*/

Select *
From interview
where person_id = '16371' or person_id = '14887'

/* We have the two interview transcripst.  I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag.
The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate 
that included "H42W".  I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.
We now have infromation about the murderer being a gold member and part of a membership number.  We also have part of a license plate number.  
We know that the killer was at the gym on january 9th. We can now analyze a few of the other tables to see if we can connect some dots.*/

Select * 
from get_fit_now_member
Where id like '48Z%' and membership_status = 'gold'

/* Two possible suspects Joe Germuska person id 28819 and Jeremy Bowers person id 67318*/

select * 
from drivers_license
where plate_number like '%H42W%'

/* We have three people with similar plate numbers, however, the id format does not match getget_fit_now_member
tables format. We can try and join the drivers license table and the person table because of the same id format.*/

select person.name, drivers_license.id, drivers_license.gender, drivers_license.plate_number
from person
join drivers_license
on person.license_id = drivers_license.id
where plate_number like '%H42W%' and gender = 'male'

/* Two possible suspect, and Jeremy Bowers is a match again.  The other person is Tushar Chandra id 664760. 
Let's see if either checked in on January 9th on the getget_fit_now_check_in table.*/

select get_fit_now_check_in.membership_id, get_fit_now_member.name,
	   get_fit_now_check_in.check_in_date, get_fit_now_member.membership_status
From get_fit_now_check_in
join get_fit_now_member
on get_fit_now_check_in.membership_id = get_fit_now_member.id
where get_fit_now_check_in.membership_id like '48Z%' and get_fit_now_check_in.check_in_date = '20180109'
	  and get_fit_now_member.membership_status = 'gold'
      
/* Jeremy Bowers is the only suspect with a membership id like '48Z', checked in on January 9th, 2018,
has a gold membership, and has a license plate number like 'H42W'.  Lets see if this person was apart of the 
interview process*/

select *
from interview
where person_id ='67318'

/*I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.
It looks like Jeremy admits to the crime and tells us there is an accomplice. */.  

select *
from (select person.name, drivers_license.id, drivers_license.gender, drivers_license.hair_color,
        drivers_license.height, drivers_license.car_make, drivers_license.car_model
		from person
		join drivers_license
		on person.license_id = drivers_license.id)
where  car_make = 'Tesla' and hair_color ='red' and gender = 'female' and height BETWEEN 65 and 67
        and car_model = 'Model S'

/* We have 3 names that match the criteria: Red Korb id 918773, Regina George id 291182, and Miranda 
Priestly id 202298.  Lets look at who visited the SQL Symphony concert 3 times in December 2017.*/ 

Select person.id, person.name, facebook_event_checkin.event_id, facebook_event_checkin.event_name,
	   facebook_event_checkin.date
from facebook_event_checkin
join person
on facebook_event_checkin.person_id = person.id
where event_name ='SQL Symphony Concert' and date like '201712%' and name = 'Red Korb' or name = 'Regina George'
      or name = 'Miranda Priestly'

/* Miranda Priestly saw the SQL Symphony Concert 3 times in December of 2017. Mirand Priestly
is the person who hired Jeremy Bowers. */

