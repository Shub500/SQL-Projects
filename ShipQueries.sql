SELECT class, country
	FROM Classes
	WHERE numGuns >= 10;


SELECT name AS shipName
	FROM Ships
	WHERE launched < 1918;



SELECT ship, battle
	FROM Outcomes
	WHERE result = ‘sunk’;

SELECT name AS sameName
FROM Ships 
WHERE Ships.name = Ships.class;


(SELECT ship AS rName FROM Outcomes WHERE ship LIKE ‘R%’)
UNION
(SELECT name AS rName FROM Ships WHERE name LIKE ‘R%’)



(SELECT ship AS threeName FROM Outcomes WHERE ship LIKE ‘%  %  %’)
UNION
(SELECT name AS threeName FROM Ships WHERE name LIKE ‘%  %  %’)
