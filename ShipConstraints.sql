CREATE TABLE CheckedClassesTable (
 	class CHAR(30) PRIMARY KEY,
type CHAR(2),
country CHAR(30),
numGuns int,
bore int,
displacement int,
CHECK (numGuns IS NULL OR numGuns <= 18 OR (numGuns > 18 AND bore < 28))
);



CREATE TABLE CheckedOutcomesTable (
		ship CHAR(30) PRIMARY KEY ,
   		 battle CHAR(30) ,
   		 result CHAR (30) ,
    		CHECK (NOT EXISTS 
(SELECT Ships.name 
  FROM Ships, Battles 
WHERE Ships.launched > Battles.date)
   		 ));
    




CREATE ASSERTION NoBothTypes CHECK 
(NOT EXISTS
		SELECT distinct c1.country
		FROM Classes c1, Classes c2
		WHERE c1.country = c2.country AND c1.type <> c2.type AND (c1.type = ‘bb’ OR c1.type = ‘bc’) AND (c2.type = ‘bb’ OR c2.type = ‘bc’));


CREATE ASSERTION MustHaveShip CHECK (NOT EXISTS (
SELECT class
FROM Classes
WHERE NOT EXISTS (SELECT class
							      FROM Ships
							     WHERE Classes.class = Ships.class AND Classes.class = Ships.name));



CREATE TRIGGER DefaultShipCreate
AFTER INSERT ON Classes
REFERENCING NEW ROW AS New
FOR EACH ROW
WHEN (2 > (SELECT COUNT(*) AS count 
FROM Classes 
WHERE class=New.class 
GROUP BY class))
BEGIN 
		INSERT INTO Ships(name, class, launched) VALUES (New.class, New.class, null);
END;
	


CREATE TRIGGER BackToAcceptableWeight
BEFORE INSERT ON Classes
REFERENCING NEW ROW AS New
FOR EACH ROW
WHEN (New.displacement > 44000)
BEGIN
	SET New.displacement = 44000;
END;	