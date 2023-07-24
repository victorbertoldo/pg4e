---- Create and populate tables

--DROP TABLE  CUSTOMER_ORDER;

--DROP TABLE CUSTOMER;

CREATE TABLE CUSTOMER_ORDER(
CUSTOMER_ID INT,
CUSTOMER_PHONE VARCHAR(20),
ORDER_ID INT, 
ORDER_DATE DATE,
SALE_AMOUNT NUMERIC(10,2));

CREATE TABLE CUSTOMER(CUSTOMER_ID INT,FIRST_NAME VARCHAR(50),LAST_NAME VARCHAR(50),PHONE_NUMBER VARCHAR(20) );


INSERT INTO CUSTOMER_ORDER VALUES (1,'339-594-1122',1,to_date('1/1/2019','mm/dd/yyyy'),54.99);
INSERT INTO CUSTOMER_ORDER VALUES (1,'339-594-1122',2,NULL,138.87);
INSERT INTO CUSTOMER_ORDER VALUES (2,'413-110-1526',3,to_date('5/15/2020','mm/dd/yyyy'),50000.98);
INSERT INTO CUSTOMER_ORDER VALUES (3,'781-324-4587',4,to_date('7/31/2020','mm/dd/yyyy'),12.45);
INSERT INTO CUSTOMER_ORDER VALUES (3,'781-324-4587',5,to_date('4/20/2019','mm/dd/yyyy'),28.45);
INSERT INTO CUSTOMER_ORDER VALUES (NULL,'781-324-4587',6,to_date('8/12/2019','mm/dd/yyyy'),85.34);
INSERT INTO CUSTOMER_ORDER VALUES (4,'(512)-178-4490',7,to_date('12/10/2019','mm/dd/yyyy'),33.43);
INSERT INTO CUSTOMER_ORDER VALUES (null,'781-123-8845',8,to_date('3/13/2020','mm/dd/yyyy'),75.44);
INSERT INTO CUSTOMER_ORDER VALUES (5,'781-123-8845',9,to_date('1/15/2020','mm/dd/yyyy'),129.12);
INSERT INTO CUSTOMER_ORDER VALUES (5,'781-123-8845',10,to_date('4/21/2020','mm/dd/yyyy'),55.38);
INSERT INTO CUSTOMER_ORDER VALUES (6,'339-594-1122',11,NULL,71.91);
INSERT INTO CUSTOMER_ORDER VALUES (6,'339-594-1122',12,NULL,110.54);

INSERT INTO CUSTOMER VALUES (1,'Joe','Doe','339-594-1122');
INSERT INTO CUSTOMER VALUES (2,'Mark','Mills','3331-4461');
INSERT INTO CUSTOMER VALUES (3,'Jonathan','Stewart','11111111');
INSERT INTO CUSTOMER VALUES (4,'Alice','Keys','(512)-178-4490');
INSERT INTO CUSTOMER VALUES (5,NULL,NULL,'7811238845');
INSERT INTO CUSTOMER VALUES (6,'Jonathan','Doe','339-594-1122');

CREATE TABLE ORDER_SALE_AMOUNT_GROUP(Order_ID,Sale_Amount,Sale_Amount_Group) AS
SELECT ORDER_ID "Order ID", SALE_AMOUNT "Sale Amount",
	CASE WHEN SALE_AMOUNT>0 AND SALE_AMOUNT<50 THEN '1. Sale Amount < 50'
		WHEN SALE_AMOUNT>50 AND SALE_AMOUNT<100 THEN '2. Sale Amount >50 AND <100'
		WHEN SALE_AMOUNT>100 AND SALE_AMOUNT<150 THEN '3. Sale Amount >100 AND <150'
		ELSE '4. Sale Amount>150' END
FROM  CUSTOMER_ORDER;