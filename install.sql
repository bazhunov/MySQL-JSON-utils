SET NAMES utf8;

DELIMITER ;;

--  Check numeric 
DROP FUNCTION IF EXISTS `ISNUMERIC`;;
CREATE FUNCTION `ISNUMERIC`(val varchar(1024)) RETURNS tinyint(1)
    DETERMINISTIC
return val regexp '^(-|\\+)?([0-9]+\\.[0-9]*|[0-9]*\\.[0-9]+|[0-9]+)$';;


-- Get JSON array value
-- If key_name is Null then JSON must include an array
DROP FUNCTION IF EXISTS `JSON_ARRAY_VALUE`;;
CREATE FUNCTION `JSON_ARRAY_VALUE`(`json` varchar(8192), `key_name` varchar(255), `indx` varchar(255)) RETURNS varchar(8192) CHARSET utf8
BEGIN
   DECLARE start,len INT;
   SET json = TRIM(json);
   IF json IS NOT NULL or json <> '' THEN
	IF key_name IS NOT NULL THEN
		SET json = JSON_VALUE(json, key_name);
	END IF;
	IF json IS NOT NULL THEN
		SELECT json  REGEXP '^[[.left-square-bracket.]].*[[.right-square-bracket.]]$' INTO start;
		IF start>0 THEN
			SET json=TRIM(SUBSTRING(json,2, length(json)-2));
			SET json = replace(substring(substring_index(json, ',', indx), length(substring_index(json, ',', indx - 1)) + 1), ',', '');
			-- Убираем из значения двойные кавычки, если это строка
			SET start=0;
			SELECT json  REGEXP '^".*"$' INTO start;  		
			IF start>0 THEN
				SET json=SUBSTRING(json,2,LENGTH(json)-2);
			END IF;
		ELSE
			SET json=NULL;
		END IF;
	END IF; 
   ELSE
	SET json=NULL;		
   END IF;
   RETURN json;
END;;



-- Get JSON value
DROP FUNCTION IF EXISTS `JSON_VALUE`;;
CREATE FUNCTION `JSON_VALUE`(`json` varchar(8192), `key_name` varchar(255)) RETURNS varchar(8192) CHARSET utf8
BEGIN
   DECLARE start,len INT;
   
   IF json IS NOT NULL or json <> '' THEN
	SET key_name=TRIM(key_name);
	SELECT key_name  REGEXP '^".*"$' INTO start;  		
	IF start = 0 THEN
		SET key_name=CONCAT('"',key_name,'"');
	END IF;
	SET start=INSTR(json,  key_name);
	IF start>0 THEN
		-- Следующий символ: ':' , поэтому отрезаем все до key и ищем его
		SET json=SUBSTRING(json,start);		
		SET start=INSTR(json,  ':')+1;
		IF start>1 THEN 
			SET json=TRIM(SUBSTRING(json,start));
			IF SUBSTRING(json,1,1) = '[' THEN
				-- Определяем длину массива по окончанию: ']' 
				SET len=INSTR(json,  ']');
				IF len>0 THEN
					SET json=TRIM(SUBSTRING(json,1, len));

				ELSE
					SET json=NULL;		
				END IF;
			ELSE		
				-- Определяем длину значения по окончанию: ',' || '}'
				SET len=INSTR(json,  ',');
				SET len=IF(len>0,len,IF(INSTR(json,  '}')>0, INSTR(json,  '}'),0));
				SET len=len-1;
				IF len>0 THEN
					SET json=TRIM(SUBSTRING(json,1, len));
					-- Убираем из значения двойные кавычки, если это строка
					SET start=0;
					SELECT json  REGEXP '^".*"$' INTO start;  		
					IF start>0 THEN
						SET json=SUBSTRING(json,2,LENGTH(json)-2);
					END IF;
				ELSE
					SET json=NULL;		
				END IF;
			END IF;

		ELSE
			SET json=NULL;		
		END IF;
	ELSE
		SET json=NULL;		
	END IF;
   ELSE
	SET json=NULL;		
   END IF;
   RETURN json;
END;;

DELIMITER ;

