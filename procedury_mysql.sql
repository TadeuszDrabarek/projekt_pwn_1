 DELIMITER //
CREATE PROCEDURE run_lesson
(IN idl int)
BEGIN
  SELECT Name, HeadOfState FROM Country
  WHERE Continent = con;
END //
DELIMITER ;