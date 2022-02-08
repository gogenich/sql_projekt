USE yoga_pro;

#колличество пользователей у каждого преподавателя
CREATE VIEW teacher_users AS
	SELECT
		t.firstname,
		t.lastname,
		count(*) AS amount
	FROM 
		class_users AS c
	JOIN
		teachers AS t
	ON c.teacher_id = t.id
	GROUP BY c.teacher_id;
	
SELECT * FROM teacher_users;

#список пользователей которые оплатили в текущем месяце
CREATE VIEW pay_users AS
	SELECT 
		u.firstname,
		u.lastname
	FROM
		users AS u
	JOIN
		payment AS p
	ON u.id = p.user_id
	WHERE 
		MONTH(p.start_subscription) = MONTH(NOW()) AND YEAR(p.start_subscription) = YEAR(NOW());
	
#триггер который автоматически высчитывает скидку и конец действия абонемента
DELIMITER //
DROP TRIGGER IF EXISTS auto_update_payment_on_insert//
CREATE TRIGGER auto_update_payment_on_insert BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
	DECLARE var INT;
	SET var = NEW.umount / 3600; #вычисляем сколько абонементов купил пользователь
	
    #заполняет конец действия абонемента	
	IF NEW.start_subscription IS NULL THEN
		SET NEW.finish_sudscription = NOW() + INTERVAL var MONTH;
	ELSE
		SET NEW.finish_sudscription = NEW.start_subscription + INTERVAL var MONTH;
	END IF;

	#вычисляем сумму оплаты с учетом скидки, если она есть
	IF NEW.discount_id IS NOT NULL THEN
		SET NEW.umount = ROUND(
								(NEW.umount * (100 - (SELECT procent FROM discount WHERE id = NEW.discount_id )) / 100), 2
							  );
	END IF;
END//
DELIMITER ;

SELECT * FROM payment;









