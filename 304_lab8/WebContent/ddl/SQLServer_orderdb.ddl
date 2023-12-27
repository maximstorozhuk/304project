CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;
DROP TABLE product;
DROP TABLE prof;
DROP TABLE admin;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE admin (
    adminId             INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (adminId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE prof (
    profId          INT IDENTITY,
    profName        VARCHAR(50), 
    profImageURL    VARCHAR(100),
    officeLocation  VARCHAR(10),   
    PRIMARY KEY (profId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(80),
    productPrice        DECIMAL(10,2),
    profImageURL        VARCHAR(100),
    productDesc         VARCHAR(1000),
    productDate         DATE,
    profId              INT,
    inventory           INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (profId) REFERENCES prof(profId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    customerId             INT,
    productId           INT,
    productName         VARCHAR(80),
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (customerId, productId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATE,   
    customerId          INT,
    profId              INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (profId) REFERENCES prof(profId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO customer(firstName, lastName, email, userId, password) VALUES ('Maxim', 'Storozhuk', 'maximstorozhuk@gmail.com', 'maximstorozhuk', 'maximstorozhuk');
INSERT INTO customer(firstName, lastName, email, userId, password) VALUES ('Lakshay', 'Dang', 'lakshaydang@gmail.com', 'lakshaydang', 'lakshaydang');

INSERT INTO admin(firstName, lastName, email, userId, password) VALUES ('Maxim', 'Storozhuk', 'maximstorozhuk@gmail.com', 'maximadmin', 'maximstorozhuk');
INSERT INTO admin(firstName, lastName, email, userId, password) VALUES ('Lakshay', 'Dang', 'lakshaydang@gmail.com', 'lakshayadmin', 'lakshaydang');



INSERT INTO prof(profName, officeLocation) VALUES ('Ramon Lawrence', 'ASC 349');
INSERT INTO prof(profName, officeLocation) VALUES ('Yves Lucet', 'ASC 350');
INSERT INTO prof(profName, officeLocation) VALUES ('Abdallah Mohamed', 'SCI 200B');
INSERT INTO prof(profName, officeLocation) VALUES ('Scott Fazackerley', 'FIP 310');
INSERT INTO prof(profName, officeLocation) VALUES ('Donovan Hare', 'SCI 113');
INSERT INTO prof(profName, officeLocation) VALUES ('Wayne Broughton', 'SCI 106');
INSERT INTO prof(profName, officeLocation) VALUES ('Paul Lee', 'FIP 310');
INSERT INTO prof(profName, officeLocation) VALUES ('Heinz Bauschke', 'ASC 352');

UPDATE Prof SET profImageURL = 'img/Ramon.jpg' WHERE ProfId = 1;
UPDATE Prof SET profImageURL = 'img/Yves.jpg' WHERE ProfId = 2;
UPDATE Prof SET profImageURL = 'img/Abdallah.jpg' WHERE ProfId = 3;
UPDATE Prof SET profImageURL = 'img/Scott.jpg' WHERE ProfId = 4;
UPDATE Prof SET profImageURL = 'img/Donovan.jpg' WHERE ProfId = 5;
UPDATE Prof SET profImageURL = 'img/Wayne.jpg' WHERE ProfId = 6;
UPDATE Prof SET profImageURL = 'img/Paul.jpg' WHERE ProfId = 7;
UPDATE Prof SET profImageURL = 'img/Heinz.jpg' WHERE ProfId = 8;

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-09-14', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, September 14', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-09-13', 'img/Yves.jpg', '20 minutes with Yves Lucet, September 13', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-09-12', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, September 12', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-09-15', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, September 15', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-09-12', 'img/Donovan.jpg', '20 minutes with Donovan Hare, September 12', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-09-15', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, September 15', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-09-13', 'img/Paul.jpg', '20 minutes with Paul Lee, September 13', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-09-14', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, September 14', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-09-21', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, September 21', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-09-20', 'img/Yves.jpg', '20 minutes with Yves Lucet, September 20', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-09-19', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, September 19', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-09-22', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, September 22', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-09-19', 'img/Donovan.jpg', '20 minutes with Donovan Hare, September 19', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-09-22', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, September 22', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-09-20', 'img/Paul.jpg', '20 minutes with Paul Lee, September 20', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-09-21', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, September 21', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-09-28', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, September 28', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-09-27', 'img/Yves.jpg', '20 minutes with Yves Lucet, September 27', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-09-26', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, September 26', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-09-29', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, September 29', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-09-26', 'img/Donovan.jpg', '20 minutes with Donovan Hare, September 26', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-09-29', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, September 29', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-09-27', 'img/Paul.jpg', '20 minutes with Paul Lee, September 27', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-09-28', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, September 28', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-10-05', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, October 5', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-10-04', 'img/Yves.jpg', '20 minutes with Yves Lucet, October 4', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-10-03', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, October 3', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-10-06', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, October 6', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-10-03', 'img/Donovan.jpg', '20 minutes with Donovan Hare, October 3', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-10-06', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, October 6', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-10-04', 'img/Paul.jpg', '20 minutes with Paul Lee, October 4', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-10-05', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, October 5', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-10-12', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, October 12', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-10-11', 'img/Yves.jpg', '20 minutes with Yves Lucet, October 11', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-10-10', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, October 10', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-10-13', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, October 13', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-10-10', 'img/Donovan.jpg', '20 minutes with Donovan Hare, October 10', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-10-13', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, October 13', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-10-11', 'img/Paul.jpg', '20 minutes with Paul Lee, October 11', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-10-12', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, October 12', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-10-19', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, October 19', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-10-18', 'img/Yves.jpg', '20 minutes with Yves Lucet, October 18', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-10-17', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, October 17', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-10-20', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, October 20', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-10-17', 'img/Donovan.jpg', '20 minutes with Donovan Hare, October 17', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-10-20', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, October 20', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-10-18', 'img/Paul.jpg', '20 minutes with Paul Lee, October 18', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-10-19', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, October 19', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-10-26', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, October 26', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-10-25', 'img/Yves.jpg', '20 minutes with Yves Lucet, October 25', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-10-24', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, October 24', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-10-27', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, October 27', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-10-24', 'img/Donovan.jpg', '20 minutes with Donovan Hare, October 24', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-10-27', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, October 27', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-10-25', 'img/Paul.jpg', '20 minutes with Paul Lee, October 25', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-10-26', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, October 26', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-11-02', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, November 2', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-11-01', 'img/Yves.jpg', '20 minutes with Yves Lucet, November 1', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-10-31', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, October 31', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-11-03', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, November 3', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-10-31', 'img/Donovan.jpg', '20 minutes with Donovan Hare, October 31', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-11-03', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, November 3', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-11-01', 'img/Paul.jpg', '20 minutes with Paul Lee, November 1', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-11-02', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, November 2', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-11-09', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, November 9', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-11-08', 'img/Yves.jpg', '20 minutes with Yves Lucet, November 8', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-11-07', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, November 7', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-11-10', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, November 10', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-11-07', 'img/Donovan.jpg', '20 minutes with Donovan Hare, November 7', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-11-10', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, November 10', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-11-08', 'img/Paul.jpg', '20 minutes with Paul Lee, November 8', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-11-09', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, November 9', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-11-16', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, November 16', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-11-15', 'img/Yves.jpg', '20 minutes with Yves Lucet, November 15', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-11-14', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, November 14', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-11-17', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, November 17', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-11-14', 'img/Donovan.jpg', '20 minutes with Donovan Hare, November 14', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-11-17', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, November 17', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-11-15', 'img/Paul.jpg', '20 minutes with Paul Lee, November 15', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-11-16', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, November 16', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-11-23', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, November 23', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-11-22', 'img/Yves.jpg', '20 minutes with Yves Lucet, November 22', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-11-21', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, November 21', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-11-24', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, November 24', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-11-21', 'img/Donovan.jpg', '20 minutes with Donovan Hare, November 21', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-11-24', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, November 24', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-11-22', 'img/Paul.jpg', '20 minutes with Paul Lee, November 22', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-11-23', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, November 23', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-11-30', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, November 30', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-11-29', 'img/Yves.jpg', '20 minutes with Yves Lucet, November 29', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-11-28', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, November 28', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-12-01', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, December 1', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-11-28', 'img/Donovan.jpg', '20 minutes with Donovan Hare, November 28', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-12-01', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, December 1', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-11-29', 'img/Paul.jpg', '20 minutes with Paul Lee, November 29', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-11-30', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, November 30', 27.18, 5);

INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (1, '2023-12-07', 'img/Ramon.jpg', '20 minutes with Ramon Lawrence, December 7', 30.01, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (2, '2023-12-06', 'img/Yves.jpg', '20 minutes with Yves Lucet, December 6', 22.22, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (3, '2023-12-05', 'img/Abdallah.jpg', '20 minutes with Abdallah Mohamed, December 5', 30.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (4, '2023-12-08', 'img/Scott.jpg', '20 minutes with Scott Fazackerley, December 8', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (5, '2023-12-05', 'img/Donovan.jpg', '20 minutes with Donovan Hare, December 5', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (6, '2023-12-08', 'img/Wayne.jpg', '20 minutes with Wayne Broughton, December 8', 28.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (7, '2023-12-06', 'img/Paul.jpg', '20 minutes with Paul Lee, December 6', 29.00, 5);
INSERT INTO product(profId, productDate, profImageURL, productName, productPrice, inventory) VALUES (8, '2023-12-07', 'img/Heinz.jpg', '20 minutes with Heinz Bauschke, December 7', 27.18, 5);

INSERT INTO ordersummary(customerId, orderDate, totalAmount) VALUES (1, '2023-09-10', 222.41);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 1, 1, 30.01);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 2, 1, 22.22);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 3, 1, 30.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 4, 1, 28.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 5, 1, 28.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 6, 1, 28.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 7, 1, 29.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (1, 8, 1, 27.18);

INSERT INTO ordersummary(customerId, orderDate, totalAmount) VALUES (2, '2023-09-10', 222.41);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 1, 1, 30.01);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 2, 1, 22.22);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 3, 1, 30.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 4, 1, 28.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 5, 1, 28.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 6, 1, 28.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 7, 1, 29.00);
INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES (2, 8, 1, 27.18);

UPDATE product SET inventory = 3 WHERE productId = 1;
UPDATE product SET inventory = 3 WHERE productId = 2;
UPDATE product SET inventory = 3 WHERE productId = 3;
UPDATE product SET inventory = 3 WHERE productId = 4;
UPDATE product SET inventory = 3 WHERE productId = 5;
UPDATE product SET inventory = 3 WHERE productId = 6;
UPDATE product SET inventory = 3 WHERE productId = 7;
UPDATE product SET inventory = 3 WHERE productId = 8;

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 1, 'Dr Lawrence was amazing! To be honest, $30.01 is a steal for getting a lab marked! Lovely to spend 20 minutes with such a knowledgable individual for such a low price!');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (1, '2023-09-25', 2, 1, 'Do not go into this expecting candy at the office hours. He only brings candy to class. Total bait.');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (4, '2023-09-24', 1, 2, 'Yves a pu mapprendre beaucoup de choses sur les structures de données de notre époque pendant les heures de bureau.');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (3, '2023-09-25', 2, 2, 'Ces heures de bureau mont vraiment aidé à obtenir une meilleure note, mais jai dû sauter des cours parce que le temps ne me convenait pas très bien, donc je ne donne quune note de trois sur cinq.');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 3, 'One of the kindest professors I have ever had. Always willing to help, and for such a low price! Worth it.');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (2, '2023-09-25', 2, 3, 'I am still mad about his nephew beating me in Mario Party, that will forever leave a bad taste in my mouth about his family. Really good teacher though.');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 4, 'I love COSC 111!');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (1, '2023-09-25', 2, 4, 'I hate COSC 211!');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 5, 'I am at a 42 in matrix algebra right now. I came to the office hours for help since I am struggling so much but Professor Hare just cracked jokes the entire time. They were funny though so I am not mad.');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (1, '2023-09-25', 2, 5, '$28.00 is way too much for office hours. I do not know who thought it was a good idea to charge people for office hours but this is getting ridiculous. I am dropping out.');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 6, 'Good old Wayne good old reliable professor can always count on this guy.');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (3, '2023-09-25', 2, 6, 'It was so inspirational when Professor Broughton said that integration was just backwards derivation. Completely changed my outlook on life. As a result, I now only save 4/5 and 5/5 reviews for the most elite of things, and I am afraid that 3/5 is the best I can leave here even though I thoroughly enjoyed Wayne Broughtons office hours.');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 7, 'Paul Lee was such a good math professor that I am going to write a song about him. Search Paul Lee on Spotify in about 3 weeks.');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (2, '2023-09-25', 2, 7, 'I swear he is cheating. There is no way he knows all of this math stuff he is definitely looking off notes.');

INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (5, '2023-09-24', 1, 8, 'Was für ein toller Lehrer. Wenn er spricht, klingt es, als würde ein Opa seinen Enkelkindern Gute-Nacht-Geschichten vorlesen. Seine Stimme ist so beruhigend und es fühlt sich an, als würde er einen ins Bett bringen');
INSERT INTO review(reviewRating, reviewDate, customerId, profId, reviewComment) VALUES (1, '2023-09-25', 2, 8, 'Over $25 to attend professor office hours? ABSURD!');
