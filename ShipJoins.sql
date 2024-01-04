SELECT name
FROM Ships NATURAL JOIN Classes
	WHERE displacement > 35000;

SELECT name, displacement, numGuns
	FROM (Outcomes  JOIN Ships ON ship = name) NATURAL JOIN Classes
	WHERE battle = ‘Guadalcanal’;
    
SELECT ship AS shipName FROM Outcomes
	UNION
	SELECT name as shipName FROM Ships;


SELECT name 
FROM Ships 
WHERE EXISTS (SELECT class 
FROM Classes 
WHERE Ships.class = Classes.class AND bore=16);


SELECT name 
FROM Ships 
WHERE class IN (SELECT class FROM Classes WHERE bore=16);

SELECT DISTINCT battle 
FROM Outcomes 
WHERE ship = ANY(SELECT name 
FROM ships 
WHERE class='Kongo');


SELECT DISTINCT battle 
FROM Outcomes 
WHERE EXISTS (SELECT name 
FROM Ships 
WHERE Ships.name = Outcomes.ship and class='Kongo');


SELECT country
		FROM Classes
		WHERE numGuns >= ALL (SELECT numGuns 
FROM Classes);

SELECT country
		FROM Classes
		WHERE numGuns IN (SELECT MAX(numGuns)
FROM Classes);

	    
    
