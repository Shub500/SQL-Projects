CREATE TRIGGER ShipGenerate
	AFTER INSERT ON Outcomes
	REFERENCING NEW ROW AS New
	FOR EACH ROW
	WHEN (New.ship NOT IN (SELECT Ships.name FROM Ships)))
BEGIN 
		INSERT INTO Ships(name, class, launched) VALUES (New.ship, null, null);
	END;

	CREATE TRIGGER BattleGenerate
	AFTER INSERT ON Outcomes
	REFERENCING NEW ROW AS New
	FOR EACH ROW
	WHEN (New.battle NOT IN (SELECT Battles.name FROM Battles))
BEGIN 
		INSERT INTO Battles(name, date) VALUES (New.battle, null);
	END;



CREATE TRIGGER 20CheckInsertV
	AFTER INSERT ON Ships
	REFERENCING NEW TABLE AS NewStuff
	FOR EACH STATEMENT
	WHEN (20 <  ANY (SELECT COUNT(Ships.name) 
FROM Classes, Ships
WHERE Ships.class = Classes.class 
GROUP BY country))

BEGIN 
		DELETE FROM Ships
		WHERE (name, class, launched) IN NewStuff
	END;

CREATE TRIGGER 20CheckUpdateVersion
	AFTER UPDATE OF class ON Ships
	REFERENCING 
OLD TABLE AS OldStuff ,
NEW TABLE AS NewStuff
	FOR EACH STATEMENT
	WHEN (20 <  ANY (SELECT COUNT(Ships.name) 
FROM Classes, Ships
WHERE Ships.class = Classes.class 
GROUP BY country)) 
BEGIN 
		DELETE FROM Ships
		WHERE (name, class, launched) IN NewStuff
		INSERT INTO Ships
				(SELECT * FROM OldStuff)
	END;



CREATE TRIGGER LogicShipsInsertV
AFTER INSERT ON Ships
REFERENCING 
	NEW TABLE AS NewStuff
FOR EACH STATEMENT
WHEN (EXIST 
SELECT CO1.ship
 FROM (Select * FROM Outcomes o1 JOIN Battles ON o1.battle = name)CO1 JOIN (Select * FROM Outcomes o2 JOIN Battles ON o2.battle = name)CO2
Where CO1.ship = CO2.ship AND CO2.result = 'sunk' AND CO1.date > CO2.date
)
		BEGIN
			DELETE FROM Ships
			WHERE (name, class, launched) IN NewStuff
		END;

CREATE TRIGGER LogicShipsUpdateV
AFTER UPDATE ON Ships
REFERENCING 
	OLD TABLE AS OldStuff ,
	NEW TABLE AS NewStuff
FOR EACH STATEMENT
WHEN (EXIST 
SELECT CO1.ship
 FROM (Select * FROM Outcomes o1 JOIN Battles ON o1.battle = name)CO1 JOIN (Select * FROM Outcomes o2 JOIN Battles ON o2.battle = name)CO2
Where CO1.ship = CO2.ship AND CO1.date > CO2.date AND CO2.result = 'sunk'
)
		BEGIN
			DELETE FROM Ships
			WHERE (name, class, launched) IN NewStuff
			INSERT INTO Ships
				(SELECT * FROM OldStuff)
		END;

		CREATE TRIGGER LogicOutcomesInsertV
AFTER INSERT ON Outcomes
REFERENCING 
	NEW TABLE AS NewStuff
FOR EACH STATEMENT
WHEN (EXIST 
SELECT CO1.ship
 FROM (Select * FROM Outcomes o1 JOIN Battles ON o1.battle = name)CO1 JOIN (Select * FROM Outcomes o2 JOIN Battles ON o2.battle = name)CO2
Where CO1.ship = CO2.ship AND CO1.date > CO2.date AND CO2.result = 'sunk'
)
		BEGIN
			DELETE FROM Outcomes
			WHERE (ship, battle, result) IN NewStuff
		END;


CREATE TRIGGER LogicOutcomesUpdateV
AFTER UPDATE ON Outcomes
REFERENCING 
	OLD TABLE AS OldStuff ,
	NEW TABLE AS NewStuff
FOR EACH STATEMENT
WHEN (EXIST 
	SELECT CO1.ship
 FROM (Select * FROM Outcomes o1 JOIN Battles ON o1.battle = name)CO1 JOIN (Select * FROM Outcomes o2 JOIN Battles ON o2.battle = name)CO2
Where CO1.ship = CO2.ship AND CO1.date > CO2.date AND CO2.result = 'sunk'
)
		BEGIN
			DELETE FROM Outcomes
			WHERE (ship, battle, result) IN NewStuff
			INSERT INTO Outcomes
				(SELECT * FROM OldStuff)
		END;


CREATE TRIGGER LogicBattlesInsertV
BEFORE INSERT ON Battles
REFERENCING 
	NEW TABLE AS NewStuff
FOR EACH STATEMENT
WHEN (EXIST 
SELECT CO1.ship
 FROM (Select * FROM Outcomes o1 JOIN Battles ON o1.battle = name)CO1 JOIN (Select * FROM Outcomes o2 JOIN Battles ON o2.battle = name)CO2
Where CO1.ship = CO2.ship AND CO1.date > CO2.date AND CO2.result = 'sunk'
)
		BEGIN
			DELETE FROM Battles
			WHERE (name, date) IN NewStuff
		END;


CREATE TRIGGER LogicBattlesUpdateV
AFTER UPDATE ON Battles
REFERENCING 
	OLD TABLE AS OldStuff ,
	NEW TABLE AS NewStuff
FOR EACH STATEMENT
WHEN (EXIST 
SELECT CO1.ship
 FROM (Select * FROM Outcomes o1 JOIN Battles ON o1.battle = name)CO1 JOIN (Select * FROM Outcomes o2 JOIN Battles ON o2.battle = name)CO2
Where CO1.ship = CO2.ship AND CO1.date > CO2.date AND CO2.result = 'sunk'
)
		BEGIN
			DELETE FROM Battles
			WHERE (name, date) IN NewStuff
			INSERT INTO Battles
				(SELECT * FROM OldStuff)
		END;