/* 1. Създайте процедура, всеки месец извършва превод от депозираната от клиента сума, с който се заплаща месечната такса. 
Нека процедурата получава като входни параметри id на клиента и сума за превод, ако преводът е успешен -
третият изходен параметър от тип BIT да приема стойност 1, в противен случай 0.
*/

DROP PROCEDURE IF EXISTS monthly_fee_paying;

DELIMITER |
CREATE PROCEDURE monthly_fee_paying (IN customerId INT, IN paying_val DOUBLE, OUT transfered BIT)
BEGIN

IF ( (SELECT amount FROM accounts WHERE customer_id = customerId) >= paying_val)
THEN 
	UPDATE accounts
    SET amount = amount - paying_val
    WHERE  customer_id = customerId;
    
    SET transfered = 1;
ELSE 
	SET transfered = 0;
END IF;

END;
|
DELIMITER ;


SET @month_transfered = 0;
CALL monthly_fee_paying(1, 200, @month_transfered);
SELECT @month_transfered;

/* 2. Създайте процедура, която извършва плащания в системата за потребителите, депозирали суми.  
Ако някое плащане е неуспешно, трябва да се направи запис в таблица длъжници. Използвайте трансакция и курсор.
*/

/*
DROP PROCEDURE IF EXISTS user_payments;
DELIMITER |
CREATE PROCEDURE user_payments()
BEGIN

DECLARE tempAmount DOUBLE;
DECLARE tempCustomId INT;
DECLARE finished INT;

DECLARE paymentCursor CURSOR FOR
SELECT paymentAmount, customer_id
FROM payments;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
SET finished = 0;

OPEN paymentCursor;

START TRANSACTION;
payment_loop: while(finished = 0)
DO
	FETCH paymentCursor INTO tempAmount, tempCustomId;
    
    IF (finished = 1)
    THEN LEAVE payment_loop;
    ELSE
		UPDATE accounts
		SET amount = amount - tempAmount
		WHERE customer_id = tempCustomId;

*/


# 3. Създайте event, който се изпълнява на 28-я ден от всеки месец и извиква втората процедура.

/*
DELIMITER |
CREATE EVENT payment_event
ON SCHEDULE EVERY 1 MONTH
STARTS '2023-05-28 03:00:00'
DO
BEGIN
	CALL user_payments();
END
|
DELIMITER ;
*/

# 4. Създайте VIEW, което да носи информация за трите имена на клиентите, дата на подписване на договор, план, дължимите суми.

CREATE VIEW contract
AS
SELECT firstName, middleName, lastName, name as planName, debt_amount
FROM customers JOIN debtors ON customer_id = customers.customerID
JOIN plans ON planID = plan_id;


/*
5. Създайте тригер, който при добавянена нов план, проверява дали въведената такса е по-малка от 10 лева. 
Ако е по-малка, то добавянето се прекратява, ако не, то се осъществява.
*/

DELIMITER |
CREATE TRIGGER prevent_Insert BEFORE INSERT ON plans
FOR EACH ROW
BEGIN
IF (NEW.monthly_fee < 10)
THEN
	SIGNAL SQLSTATE '45000';
END IF;
END
|
DELIMITER ;



/*
6. Създайте тригер, който при добавяне на сума в клиентска сметка проверява дали сумата, която трябва да бъде добавена 
не е по-малка от дължимата сума. Ако е по-малка, то добавянето се прекратява, ако не, то се осъществява.
*/

DROP TRIGGER IF EXISTS amount_debt_check;
DELIMITER |
CREATE TRIGGER amount_debt_check BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
IF (NEW.amount - Old.amount < (SELECT SUM(debt_amount) FROM debtors WHERE customer_id = OLD.customer_id))
THEN
	SIGNAL SQLSTATE '45000';
END IF;
END;
|
DELIMITER ;



# 7. Създайте процедура, която при подадени имена на клиент извежда всички данни за клиента, както и извършените плащания.
DROP PROCEDURE IF EXISTS client_info;
DELIMITER |
CREATE PROCEDURE client_info (IN firstName VARCHAR(55), IN middleName VARCHAR(55), IN lastName VARCHAR(55))
BEGIN
SELECT *
FROM customers JOIN debtors ON customerID = customer_id;
END;
|
DELIMITER ;


CALL client_info('Kiril', 'Stef', 'Week');
