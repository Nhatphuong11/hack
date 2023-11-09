CREATE DATABASE IF NOT EXISTS QUANLYBANHANG;

USE QUANLYBANHANG;

CREATE TABLE IF NOT EXISTS CUSTOMERS	
(
    CUSTOMERS_id   VARCHAR(50) NOT NULL PRIMARY KEY,
    CUSTOMERS_name VARCHAR(30) NOT NULL,
    email     VARCHAR(50) NOT NULL UNIQUE,
    Address     VARCHAR(50) NOT NULL,
    Phone       VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS ORDERS	
(
    order_id   VARCHAR(50) NOT NULL PRIMARY KEY,
    CUSTOMERS_id VARCHAR(30) NOT NULL,
    ORDERS_date DATE,
    total_amount double NOT NULL,
    FOREIGN KEY (CUSTOMERS_id) REFERENCES CUSTOMERS(CUSTOMERS_id)
);

CREATE TABLE IF NOT EXISTS PRODUCTS	
(
    product_id   VARCHAR(50) NOT NULL PRIMARY KEY,
    PRODUCTS_name VARCHAR(30) NOT NULL,
    Descriptionn     text,
    price double,
    statuss bit 
);

CREATE TABLE IF NOT EXISTS ORDERS_DETAILS	
(
    order_id   VARCHAR(50) NOT NULL,
    product_id   VARCHAR(50) NOT NULL,
    quantity int(11),
    price double,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
);

INSERT INTO CUSTOMERS (CUSTOMERS_id , CUSTOMERS_name , email, Phone, Address)
VALUES
    ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '555-123-4567', 'Cầu Giấy, Hà Nội'),
    ('C002', 'Hồ Hải Nam', 'namhh@email.com', '555-987-6543', 'Ba Vì, Hà Nội'),
    ('C003', 'Tô Ngọc Vũ', 'vutn@email.com', '555-111-2222', 'Mộc Châu, Sơn La'),
    ('C004', 'Phạm Ngọc Anh', 'anhpn@email.com', '555-888-9999', 'Vinh, Nghệ An'),
    ('C005', 'Trương Minh Cường', 'cuongtm@email.com', '555-444-3333', 'Hai Bà Trưng, Hà Nội');

INSERT INTO PRODUCTS (product_id, PRODUCTS_name, Descriptionn, price, statuss)
VALUES
    ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
    ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999, 1),
    ('P003', 'Macbook Pro M2', '8 CPU 10 GPU 8GB 256GB', 28999999, 1),
    ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
    ('P005', 'Airpods', 'Spatial Audio', 4090000, 1);

INSERT INTO ORDERS (order_id, CUSTOMERS_id, total_amount, ORDERS_date)
VALUES  
    ('H001', 'C001', 52999997, '2023-02-22'),
    ('H002', 'C001', 80999997, '2023-03-11'),
	('H003', 'C002', 54359998, '2023-01-22'),
	('H004', 'C003', 102999995, '2023-03-14'),
	('H005', 'C003', 80999997, '2023-02-1'),
    ('H006', 'C004', 112424242, '2023-02-22'),
    ('H007', 'C004', 42424242, '2023-03-29'),
    ('H008', 'C005', 767676754, '2023-02-14'),
    ('H009', 'C005', 535353535, '2023-01-10'),
    ('H010', 'C005', 535354355, '2023-04-1');
    
INSERT INTO ORDERS_DETAILS(order_id, product_id, quantity, price)
VALUES ('H001', 'P002', 1, 14999999),
('H001', 'P004', 2, 18999999),
('H002', 'P001', 1, 22999999),
('H002', 'P003', 2, 28999999),
('H003', 'P004', 2, 18999999),
('H003', 'P005', 4, 4090000),
('H004', 'P002', 3, 14999999),
('H004', 'P003', 2, 28999999),
('H005', 'P001', 1, 22999999),
('H005', 'P003', 2, 28999999),
('H006', 'P005', 5, 4090000),
('H006', 'P002', 6, 14999999),
('H007', 'P004', 3, 18999999),
('H007', 'P001', 1, 22999999),
('H008', 'P002', 2, 14999999),
('H009', 'P003', 1, 28999999),
('H010', 'P003', 2, 28999999),
('H010', 'P001', 4, 22999999);    

-- bài 3
-- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers .
SELECT CUSTOMERS_name, email, Phone, Address
FROM CUSTOMERS;

-- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng).
SELECT c.CUSTOMERS_name, c.Phone, c.Address
FROM CUSTOMERS c
JOIN ORDERS o ON c.CUSTOMERS_id = o.CUSTOMERS_id
WHERE YEAR(o.ORDERS_date) = 2023 AND MONTH(o.ORDERS_date) = 3;

-- Thống kê doanh thua theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu).
SELECT MONTH(ORDERS_date) AS Month, SUM(total_amount) AS 'tổng doanh thu'
FROM ORDERS
WHERE YEAR(ORDERS_date) = 2023
GROUP BY MONTH(ORDERS_date);
	
-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại).
SELECT
    c.CUSTOMERS_name AS 'Tên khách hàng',
    c.Address AS 'Địa chỉ',
    c.email AS 'Email',
    c.Phone AS 'Số điện thoại'
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMERS_id = o.CUSTOMERS_id
WHERE o.ORDERS_date IS NULL OR (MONTH(o.ORDERS_date) = 2);

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra).
SELECT
    p.product_id AS 'Mã sản phẩm',
    p.PRODUCTS_name AS 'Tên sản phẩm',
    (
        SELECT SUM(od.quantity)
        FROM ORDERS o
        LEFT JOIN ORDERS_DETAILS od ON o.order_id = od.order_id
        WHERE MONTH(o.ORDERS_date) = 3
        AND od.product_id = p.product_id
    ) AS 'Số lượng bán ra'
FROM PRODUCTS p
ORDER BY p.product_id;
    
-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu). 
SELECT
    c.CUSTOMERS_id AS 'Mã khách hàng',
    c.CUSTOMERS_name AS 'Tên khách hàng',
    SUM(o.total_amount) AS 'Mức chi tiêu'
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMERS_id = o.CUSTOMERS_id
WHERE YEAR(o.ORDERS_date) = 2023
GROUP BY c.CUSTOMERS_id, c.CUSTOMERS_name
ORDER BY 'Mức chi tiêu' DESC;

 /* Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)*/
SELECT
    c.CUSTOMERS_name AS 'Tên người mua',
    o.total_amount AS 'Tổng tiền',
    o.ORDERS_date AS 'Ngày tạo hoá đơn',
    SUM(od.quantity) AS 'Tổng số lượng sản phẩm'
FROM CUSTOMERS c
INNER JOIN ORDERS o ON c.CUSTOMERS_id = o.CUSTOMERS_id
INNER JOIN ORDERS_DETAILS od ON o.order_id = od.order_id
GROUP BY c.CUSTOMERS_name, o.total_amount, o.ORDERS_date
HAVING SUM(od.quantity) >= 5;

-- bài4
/*Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
tiền và ngày tạo hoá đơn .*/
CREATE VIEW viewoder AS
SELECT
    c.CUSTOMERS_name AS 'Tên khách hàng',
    c.Phone AS 'Số điện thoại',
    c.Address AS 'Địa chỉ',
    o.total_amount AS 'Tổng tiền',
    o.ORDERS_date AS 'Ngày tạo hoá đơn'
FROM CUSTOMERS c
INNER JOIN ORDERS o ON c.CUSTOMERS_id = o.CUSTOMERS_id;

/* Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng
số đơn đã đặt.*/
CREATE VIEW viewInfo AS
SELECT
    c.CUSTOMERS_name AS 'Tên khách hàng',
    c.Address AS 'Địa chỉ',
    c.Phone AS 'Số điện thoại',
    COUNT(o.order_id) AS 'Tổng số đơn đã đặt'
FROM CUSTOMERS c
LEFT JOIN ORDERS o ON c.CUSTOMERS_id = o.CUSTOMERS_id
GROUP BY c.CUSTOMERS_name, c.Address, c.Phone;

/*Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
bán ra của mỗi sản phẩm*/
CREATE VIEW viewproduct AS
SELECT
    p.PRODUCTS_name AS 'Tên sản phẩm',
    p.Descriptionn AS 'Mô tả',
    p.price AS 'Giá',
    SUM(od.quantity) AS 'Tổng số lượng đã bán ra'
FROM PRODUCTS p
LEFT JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
GROUP BY p.PRODUCTS_name, p.Descriptionn, p.price;

-- Đánh Index cho trường `phone` và `email` của bảng Customer.
CREATE INDEX index_phone ON CUSTOMERS (Phone);
-- Tạo Index cho trường Email
CREATE INDEX indx_email ON CUSTOMERS (email);

-- Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER &&
CREATE PROCEDURE CustomerInfo(IN customerId VARCHAR(50))
BEGIN
    SELECT *
    FROM CUSTOMERS
    WHERE CUSTOMERS_id = customerId;
END &&
DELIMITER 
CALL CustomerInfo('C001');

-- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm.
DELIMITER 
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT *
    FROM PRODUCTS;
END 
DELIMITER ;

CALL GetAllProducts();

-- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER &&
CREATE PROCEDURE listoder(IN oderId VARCHAR(50))
BEGIN
    SELECT *
    FROM ORDERS
    WHERE CUSTOMERS_id  = oderId;
END &&
DELIMITER 

CALL listoder('C001');


