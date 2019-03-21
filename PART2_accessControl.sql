-- PART 2
-- CASUAL USER WHO DOES NOT HAVE AN ACCOUNT IN YELP
-- VIEW RELATED WITH BUSINESS
CREATE VIEW BUSINESSVIEWBUSINESS1 AS SELECT b.name as Nameofbusiness, b.neighborhood,
b.address, b.city, b.state, b.postal_code,latitude, b.longitude, b.stars, b.review_count, b.is_open,
ba.name as Nameofcategory,ba.value,
bc.category,
bch.count,bch.date,
bh.hours,
bp.caption, bp.label
FROM business as b inner join attribute as ba on b.id=ba.business_id
inner join category as bc on b.id=bc.business_id
inner join checkin as bch on b.id=bch.business_id
inner join hours as bh on  b.id=bh.business_id
inner join photo as bp on b.id=bp.business_id; 

-- VIEW RELATED WITH USER
CREATE VIEW AUXUSERFRIEND AS SELECT uf.user_id, u.name as Name_friend 
from friend as uf inner join user as u on u.id=uf.friend_id;
CREATE VIEW USERVIEW1 AS SELECT u.name,u.review_count, u.yelping_since, u.useful, u.funny, u.cool, 
u.fans, u.average_stars, u.compliment_hot, u.compliment_more,u.compliment_profile,u.compliment_cute, 
u.compliment_list, u.compliment_note, u.compliment_plain,u.compliment_cool,u.compliment_funny,
u.compliment_writer,u.compliment_photos,
Auxuser.Name_friend,
uey.year
from user as u inner join AUXUSERFRIEND as Auxuser on u.id=Auxuser.user_id
inner join elite_years as uey on u.id=uey.user_id;

-- VIEW RELATED WITH INFORMATION ABOUT REVIEW

CREATE VIEW USER_BUSINESS_REVIEW AS SELECT u.name as Username, b.name as BusinessName,
r.stars,r.date,r.text, r.useful, r.funny, r.cool 
from review as r inner join user as u on u.id=r.user_id 
inner join business as b on b.id=r.business_id;

-- VIEW RELATED WITH INFORMATION ABOUT TIP
CREATE VIEW USER_BUSINESS_TIP AS SELECT u.name as Username, b.name as BusinessName,
t.text, t.date, t.likes 
from tip as t inner join user as u on u.id=t.user_id 
inner join business as b on b.id=t.business_id;

-- PERMISSIONS CREATED FOR A CASUAL USER 
create user 'user1'@'localhost';
grant select on yelp_db.USER_BUSINESS_TIP to 'user1'@'localhost'; 
grant select on yelp_db.USER_BUSINESS_REVIEW to 'user1'@'localhost'; 
grant select on yelp_db.USERVIEW1 to 'user1'@'localhost'; 
grant select on yelp_db. BUSINESSVIEWBUSINESS1 to 'user1'@'localhost'; 
flush PRIVILEGES;

-- PERMISSIONS CREATED FOR A USER WITH AN ACCOUNT IN YELP
create user 'user2'@'localhost'IDENTIFIED BY '123';
grant select on yelp_db.USER_BUSINESS_TIP to 'user2'@'localhost';
grant select on yelp_db.USER_BUSINESS_REVIEW to 'user2'@'localhost'; 
grant select on yelp_db.USERVIEW1 to 'user2'@'localhost'; 
grant select on yelp_db. BUSINESSVIEWBUSINESS1 to 'user2'@'localhost'; 
grant insert,update ,delete on yelp_db.review to 'user2'@'localhost'; 

-- PERMISSIONS CREATED FOR A DATA ANALYST USER
create user 'user3'@'localhost'IDENTIFIED BY '345';
grant select on yelp_db.* to 'user3'@'localhost';
grant create view on yelp_db.* to 'user3'@'localhost';

-- PERMISSIONS CREATED FOR A DEVELOPER USER
create user 'user4'@'localhost'IDENTIFIED BY '567';
grant select,insert,update,delete on yelp_db.* to 'user4'@'localhost';
grant create view on yelp_db.* to 'user4'@'localhost';
grant create on yelp_db.* to 'user4'@'localhost';
grant index on yelp_db.* to 'user4'@'localhost';

-- PERMISSIONS CREATED FOR A ROOT USER
create user 'user5'@'localhost'IDENTIFIED BY '789';
grant all on yelp_db.* to 'user5'@'localhost' with grant option;
