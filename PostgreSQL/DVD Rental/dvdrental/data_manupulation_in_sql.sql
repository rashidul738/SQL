UPDATE public.fruits
	SET fruit_id=1, fruit_name='water milon'
	WHERE fruit_id = 1;



UPDATE fruits
	SET fruit_name = 'Jackfruit'
	WHERE fruit_id = 3;


SELECT * FROM fruits ORDER BY fruit_id ASC;


DELETE FROM fruits
	WHERE fruit_id = 3;


TRUNCATE TABLE fruits;

DROP TABLE fruits;





