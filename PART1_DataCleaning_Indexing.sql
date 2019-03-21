-- PART 1
--# ADD FOREIGN KEYS

ALTER TABLE `category` ADD CONSTRAINT `fk_Category_bussiness` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `tip` ADD CONSTRAINT `fk_tip_bussiness` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `tip` ADD CONSTRAINT `fk_tip_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `hours` ADD CONSTRAINT `fk_hours_bussiness` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `photo` ADD CONSTRAINT `fk_photo_bussiness` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `checkin` ADD CONSTRAINT `fk_checkin_bussiness` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `attribute` ADD CONSTRAINT `fk_attribute_bussiness` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `elite_years` ADD CONSTRAINT `fk_eliteyears_bussiness` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `review` ADD CONSTRAINT `fk_review_business` FOREIGN KEY (`business_id`) REFERENCES `business` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `review` ADD CONSTRAINT `fk_Category_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE；

ALTER TABLE `friend` ADD CONSTRAINT `fk_friend_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

USE yelp_db;

-- SELF CONSISTENCY IN THE RELATIONS WITH DATA ABOUT BUSINESS
-- Query to verify self-consistency of the attribute business_id in the relation hours 
ALTER TABLE `hours` ADD INDEX `idx_hours_businessid` (`business_id`) USING BTREE;
  (SELECT hours.id
   FROM hours
     LEFT JOIN `business`
       ON hours.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );

-- Query to verify self-consistency of the attribute business_id in the relation category 
ALTER TABLE `category` ADD INDEX `idx_category_businessid` (`business_id`) USING BTREE;
  (SELECT category.id
   FROM category
     LEFT JOIN `business`
       ON category.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );
  
-- Query to verify self-consistency of the attribute business_id in the relation attribute
   
ALTER TABLE `attribute` ADD INDEX `idx_attribute_businessid` (`business_id`) USING BTREE;
  (SELECT attribute.id
   FROM attribute
     LEFT JOIN `business`
       ON attribute.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );
  
-- Query to verify self-consistency of the attribute business_id in the relation checkin
  
ALTER TABLE `checkin` ADD INDEX `idx_checkin_businessid` (`business_id`) USING BTREE;
  (SELECT checkin.id
   FROM checkin
     LEFT JOIN `business`
       ON checkin.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );
  
-- Query to verify self-consistency of the attribute business_id in the relation tip
ALTER TABLE `tip` ADD INDEX `idx_tip_businessid` (`business_id`) USING BTREE;
  (SELECT tip.id
   FROM tip
     LEFT JOIN `business`
       ON tip.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );
  
-- Query to verify self-consistency of the attribute business_id in the relation photo
  
ALTER TABLE `photo` ADD INDEX `idx_photo_businessid` (`business_id`) USING BTREE;
  (SELECT photo.id
   FROM photo
     LEFT JOIN `business`
       ON photo.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );
  
-- Query to verify self-consistency of the attribute business_id in the relation review
ALTER TABLE `review` ADD INDEX `idx_review_businessid` (`business_id`) USING BTREE;
  (SELECT review.id
   FROM review
     LEFT JOIN `business`
       ON review.business_id= `business`.`id`
   WHERE `business`.`id` IS NULL
  );


-- SELF CONSISTENCY IN THE RELATIONS WITH DATA ABOUT USER
-- Query to verify self-consistency of the attribute user_id in the relation review
ALTER TABLE `review` ADD INDEX `idx_review_userid` (`user_id`) USING BTREE;
  (SELECT review.id
   FROM review
     LEFT JOIN `user`
       ON review.user_id= `user`.`id`
   WHERE `user`.`id` IS NULL
  );
-- Query to verify self-consistency of the attribute user_id in the relation friend

ALTER TABLE `friend` ADD INDEX `idx_friend_userid` (`user_id`) USING BTREE;
  (SELECT friend.id
   FROM friend
     LEFT JOIN `user`
       ON friend.user_id= `user`.`id`
   WHERE `user`.`id` IS NULL
  );
  
-- Query to verify self-consistency of the attribute user_id in the relation elite_years
ALTER TABLE `elite_years` ADD INDEX `idx_elite_years_userid` (`user_id`) USING BTREE;
  (SELECT elite_years.id
   FROM elite_years
     LEFT JOIN `user`
       ON elite_years.user_id= `user`.`id`
   WHERE `user`.`id` IS NULL
  );
  

-- Query to verify self-consistency of the attribute user_id in the relation tip

ALTER TABLE `tip` ADD INDEX `idx_tip_userid` (`user_id`) USING BTREE;
  (SELECT tip.id
   FROM tip
     LEFT JOIN `user`
       ON tip.user_id= `user`.`id`
   WHERE `user`.`id` IS NULL
  );
  
  
-- Query to verify self-consistency of the attribute user_id in the relation friend
ALTER TABLE `friend` ADD INDEX `idx_friendid_userid` (`friend_id`) USING BTREE;
SELECT friend.id from friend where friend.id not in (select id from user);
 
  (SELECT friend.id
  FROM friend
    LEFT JOIN `user`
      ON friend.friend_id= `user`.`id`
  WHERE `user`.`id` IS NULL
  );
 
   -- CHECK SANITY IN THE RELATION USER ACCORDING TO DATE OF CREATION OF AN ACCOUNT IN YELP AND FUTURE DATES
  
SELECT id FROM user WHERE YEAR(yelping_since) < 2004;
SELECT id FROM user WHERE YEAR(yelping_since) >2018;
  
    -- CHECK SANITY IN THE RELATION ELITE_YEARS ACCORDING TO DATE OF CREATION OF AN ACCOUNT IN YELP, FUTURE DATES, AND OTHER CONSIDERATIONS 

SELECT id FROM elite_years WHERE CONVERT(year USING utf8) < 2004;
SELECT id FROM elite_years WHERE CONVERT(year USING utf8) > 2018;
  
ALTER TABLE `user` ADD INDEX `idx_eliteyears_useryear` (`yelping_since`) USING BTREE;
ALTER TABLE `elite_years` ADD INDEX `idx_useryear_eliteyears` (`year`) USING BTREE;
create view  v3 as select user_id, min(CONVERT(year USING utf8)) AS minyear from elite_years group by user_id order by user_id;
SELECT user_id FROM V3 INNER JOIN user as u on V3.user_id=u.id where v3.minyear<YEAR(yelping_since);

   
  -- CHECK SANITY IN THE RELATION REVIEWS ACCORDING TO DATE OF CREATION OF AN ACCOUNT IN YELP, FUTURE DATES, AND OTHER CONSIDERATIONS
  
SELECT id FROM review WHERE YEAR(date) < 2004;
SELECT id FROM review WHERE YEAR(date) > 2018;

ALTER TABLE `review` ADD INDEX `idx_reviewdate_reviewuserid` (`date`,`user_id`) USING BTREE;
ALTER TABLE `user` ADD INDEX `idx_userid_yearsince` (`yelping_since`,`id`) USING BTREE;
create view  v4 as select user_id, min(YEAR(date)) AS minyear1 from review group by user_id order by user_id;
SELECT v4.user_id FROM v4 INNER JOIN user as u on v4.user_id=u.id where v4.minyear1<YEAR(yelping_since);
  

  
  -- CHECK SANITY IN THE RELATION TIP ACCORDING TO DATE OF CREATION OF AN ACCOUNT IN YELP, FUTURE DATES, AND OTHER CONSIDERATIONS

SELECT id FROM tip WHERE YEAR(date) < 2004;
SELECT id FROM tip WHERE YEAR(date) > 2018;
ALTER TABLE `tip` ADD INDEX `idx_tipdate_tipuserid` (`date`,`user_id`) USING BTREE;
create view  v5 as select user_id, min(YEAR(date)) AS minyear2 from tip group by user_id order by user_id;
create view v6 as select id, YEAR(yelping_since) as minyearuser from user order by id;
select user_id from v6,v5 where v5.user_id=v6.id and minyear2<minyearuser; 
SELECT  v5.user_id FROM v5 INNER JOIN user as u on v5.user_id=u.id where v5.minyear2<YEAR(yelping_since);

  
-- NUMBER OF AVERAGE OF STARS PER USER IN THE RELATION USER COMPARED WITH THE AVERAGE OF STARS IN THE REALATION REVIEW

ALTER TABLE `user` ADD INDEX `idx_user_id_average_stars` (`id`,`average_stars`) USING BTREE;
ALTER TABLE `review` ADD INDEX `idx_review_user_stars` (`user_id`,`stars`) USING BTREE;
CREATE VIEW USER_STARS AS SELECT u.id as user_stars_id, avg(u.average_stars) as user_average_stars from user as u group by u.id;
CREATE VIEW USER_REVIEW AS SELECT r.user_id as review_user_id, avg(r.stars) as review_user_stars from review as r group by r.user_id;
CREATE VIEW FINAL_USER_CONDITION AS SELECT ur.review_user_id as total_users_condition from USER_REVIEW as ur inner join USER_STARS as us on us.user_stars_id=ur.review_user_id where (abs(us.user_average_stars-ur.review_user_stars))>0.5 group by us.user_stars_id ;
SELECT count(total_users_condition) from FINAL_USER_CONDITION;

-- COMPARISON BETWEEN NUMBER OF REVIEWS IN THE RELATION USER COMPARED WITH THE NUMBER OF REVIEWS IN THE RELATION USER
ALTER TABLE `user` ADD INDEX `idx_user_id_review_count` (`id`,`review_count`) USING BTREE;
CREATE VIEW USER_ID_COUNT AS SELECT user_id as user_review_count, count(user_id) as count_of_review_per_user from review group by user_id;
select id,review_count, count_of_review_per_user from user inner join USER_ID_COUNT on id=user_review_count where review_count<count_of_review_per_user;
select count(id) from user inner join USER_ID_COUNT on id=user_review_count where review_count<count_of_review_per_user;
-- DATA CLEANING 1 
delete from user where review_count < (select count_of_review_per_user from USER_ID_COUNT) and id=(select user_review_count from USER_ID_COUNT);
-- NUMBER OF AVERAGE STARS PER BUSINESS IN THE RELATION BUSINESS COMPARED WITH THE AVERAGE OF STARS CALCULATED BY GROUPING IN THE RELATION REVIEW.
ALTER TABLE `business` ADD INDEX `idx_business_id_stars` (`id`,`stars`) USING BTREE;
ALTER TABLE `review` ADD INDEX `idx_review_business_stars` (`business_id`,`stars`) USING BTREE;
CREATE VIEW BUSINESS_REVIEW AS SELECT business_id as review_business_id, avg(stars) as review_business_stars from review group by business_id;
CREATE VIEW FINAL_BUSINESS_CONDITION AS SELECT br.review_business_id as total_business_condition, br.review_business_stars 
from BUSINESS_REVIEW as br inner join business as b on b.id=br.review_business_id where(abs(br.review_business_stars-b.stars))>0.5 
group by br.review_business_stars;
SELECT count(total_business_condition) from FINAL_BUSINESS_CONDITION;



  

