INSERT INTO RESERVATION VALUES (
	(select uID from user where uID = 1),
	(select cID from court where cID = 1),
	(select tid from time where tid = 1),
	'no');
INSERT INTO RESERVATION VALUES (
	(select uID from user where uID = 2),
	(select cID from court where cID = 1),
	(select tid from time where tid = 2),
	'yes');