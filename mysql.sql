-- Step 1: Drop existing tables if they exist to clean up the database
DROP TABLE IF EXISTS order_item CASCADE;
DROP TABLE IF EXISTS cart_item CASCADE;
DROP TABLE IF EXISTS customer_order CASCADE;
DROP TABLE IF EXISTS cart CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

-- Step 2: Create the customer table
CREATE TABLE customer (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  address VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 3: Create the product table
CREATE TABLE product (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  stock_quantity INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 4: Create the cart table
CREATE TABLE cart (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE
);

-- Step 5: Create the cart_item table
CREATE TABLE cart_item (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  cart_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (cart_id) REFERENCES cart(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Step 6: Create the customer_order table
CREATE TABLE customer_order (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  customer_id BIGINT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE
);

-- Step 7: Create the order_item table
CREATE TABLE order_item (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES customer_order(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Step 8: Create indexes for faster query performance
CREATE INDEX cart_customer_id_idx ON cart (customer_id);
CREATE INDEX cart_item_cart_id_idx ON cart_item (cart_id);
CREATE INDEX cart_item_product_id_idx ON cart_item (product_id);
CREATE INDEX customer_order_customer_id_idx ON customer_order (customer_id);
CREATE INDEX order_item_order_id_idx ON order_item (order_id);
CREATE INDEX order_item_product_id_idx ON order_item (product_id);

-- Step 9: Insert sample customer records
INSERT INTO customer (username, first_name, last_name, address) VALUES
('user1', 'Aarav', 'Sharma', '123, MG Road, Mumbai, Maharashtra, 400001'),
('user2', 'Vivaan', 'Patel', '56, Shivaji Nagar, Pune, Maharashtra, 411033'),
('user3', 'Aditya', 'Singh', '789, Ganga Street, Delhi, 110001'),
('user4', 'Sai', 'Reddy', '12, Banjara Hills, Hyderabad, Telangana, 500018'),
('user5', 'Ishaan', 'Yadav', '45, Vikas Nagar, Kanpur, Uttar Pradesh, 208001'),
('user6', 'Arjun', 'Gupta', '67, Janki Vihar, Jaipur, Rajasthan, 302018'),
('user7', 'Aanya', 'Mehta', '23, Kalyani Nagar, Ahmedabad, Gujarat, 380001'),
('user8', 'Saanvi', 'Jain', '32, Salt Lake, Kolkata, West Bengal, 700091'),
('user9', 'Krishna', 'Verma', '90, Rajendra Nagar, Patna, Bihar, 800001'),
('user10', 'Reyansh', 'Malik', '56, Naya Bazar, Lucknow, Uttar Pradesh, 226001'),
('user11', 'Prisha', 'Kumar', '22, Lajpat Nagar, Delhi, 110024'),
('user12', 'Raghav', 'Shukla', '38, Ghazipur, Varanasi, Uttar Pradesh, 221001'),
('user13', 'Aaradhya', 'Saini', '90, Sector 10, Noida, Uttar Pradesh, 201301'),
('user14', 'Kiaan', 'Bhatia', '12, Sector 5, Gurgaon, Haryana, 122018'),
('user15', 'Maanvi', 'Chopra', '4, Beliaghata, Kolkata, West Bengal, 700015'),
('user16', 'Kabir', 'Sahu', '56, M.G. Road, Bhubaneswar, Odisha, 751001'),
('user17', 'Tanya', 'Sharma', '234, Chakala, Mumbai, Maharashtra, 400099'),
('user18', 'Ananya', 'Agarwal', '78, Chandni Chowk, Delhi, 110006'),
('user19', 'Arnav', 'Joshi', '33, MG Road, Bangalore, Karnataka, 560001'),
('user20', 'Kavya', 'Rao', '10, HSR Layout, Bangalore, Karnataka, 560102'),
('user21', 'Manav', 'Kumar', '67, Anand Vihar, Delhi, 110092'),
('user22', 'Avi', 'Sharma', '49, Sadar Bazar, Agra, Uttar Pradesh, 282003'),
('user23', 'Ritika', 'Bhatt', '22, Shastri Nagar, Jaipur, Rajasthan, 302019'),
('user24', 'Siddharth', 'Mehra', '57, Koyambedu, Chennai, Tamil Nadu, 600107'),
('user25', 'Pihu', 'Khandelwal', '33, Malleswaram, Bangalore, Karnataka, 560003'),
('user26', 'Rishabh', 'Desai', '45, MG Road, Pune, Maharashtra, 411045'),
('user27', 'Simran', 'Singh', '90, Alambagh, Lucknow, Uttar Pradesh, 226005'),
('user28', 'Pranav', 'Nair', '12, Powai, Mumbai, Maharashtra, 400076'),
('user29', 'Shivansh', 'Pandey', '87, Jodhpur Park, Kolkata, West Bengal, 700068'),
('user30', 'Vansh', 'Tiwari', '15, Chandrapuri, Bhopal, Madhya Pradesh, 462002'),
('user31', 'Avi', 'Shukla', '3, Rajouri Garden, Delhi, 110027'),
('user32', 'Kiara', 'Verma', '77, Ghaziabad, Uttar Pradesh, 201009'),
('user33', 'Yash', 'Patel', '20, Ashok Nagar, Surat, Gujarat, 395007'),
('user34', 'Shivani', 'Aggarwal', '2, Khar West, Mumbai, Maharashtra, 400052'),
('user35', 'Vihan', 'Singh', '18, Civil Lines, Allahabad, Uttar Pradesh, 211001'),
('user36', 'Sana', 'Rathore', '24, Shankar Nagar, Raipur, Chhattisgarh, 492001'),
('user37', 'Madhav', 'Verma', '44, Shalimar Bagh, Delhi, 110088'),
('user38', 'Diya', 'Rani', '11, Sector 12, Chandigarh, 160012'),
('user39', 'Soham', 'Gupta', '99, Sanjay Nagar, Kanpur, Uttar Pradesh, 208022'),
('user40', 'Tanvi', 'Mehra', '55, Pimple Saudagar, Pune, Maharashtra, 411027'),
('user41', 'Ved', 'Iyer', '77, Rajput Nagar, Chennai, Tamil Nadu, 600024'),
('user42', 'Tanish', 'Ahuja', '88, Moti Bagh, New Delhi, 110021'),
('user43', 'Jai', 'Bansal', '9, Sadar Bazar, Jaipur, Rajasthan, 302006'),
('user44', 'Harshita', 'Yadav', '65, Gandhi Nagar, Kanpur, Uttar Pradesh, 208003'),
('user45', 'Riya', 'Singh', '40, DLF Phase 3, Gurgaon, Haryana, 122002'),
('user46', 'Pooja', 'Chatterjee', '27, New Town, Kolkata, West Bengal, 700156'),
('user47', 'Raj', 'Kumar', '9, Sector 5, Noida, Uttar Pradesh, 201301'),
('user48', 'Neha', 'Bhagat', '70, Sarita Vihar, Delhi, 110044'),
('user49', 'Rohit', 'Jain', '19, South Extension, Delhi, 110049'),
('user50', 'Shreya', 'Patel', '33, Gandhi Market, Surat, Gujarat, 395003');

-- Step 10: Insert sample product records
INSERT INTO product (name, price, stock_quantity) VALUES
('Samsung Galaxy A54', 24999.99, 100),
('Apple iPhone 14', 79999.99, 50),
('OnePlus 11', 55999.99, 120),
('Realme Narzo 50', 11999.99, 200),
('Xiaomi Redmi Note 12', 14999.99, 150),
('Sony Bravia 55 Inch TV', 74999.99, 40),
('LG OLED 65 Inch TV', 159999.99, 30),
('Lenovo ThinkPad Laptop', 74999.99, 70),
('HP Pavilion Laptop', 64999.99, 100),
('Canon EOS 1500D Camera', 34999.99, 80),
('GoPro HERO 11', 45999.99, 60),
('Washing Machine LG', 19999.99, 150),
('Whirlpool Refrigerator', 34999.99, 80),
('iRobot Roomba Vacuum', 29999.99, 50),
('Samsung 32 Inch LED TV', 18999.99, 150),
('Bose QuietComfort Headphones', 27999.99, 90),
('JBL Flip 5 Bluetooth Speaker', 9999.99, 200),
('Apple AirPods Pro', 24999.99, 100),
('Mi Smart Band 6', 2999.99, 300),
('Fujifilm Instax Mini Camera', 6999.99, 120),
('Nikon D3500 Camera', 34999.99, 70),
('Apple Watch Series 8', 41999.99, 60),
('Garmin Fenix 6 Smartwatch', 55999.99, 30),
('Nike Running Shoes', 4999.99, 200),
('Adidas UltraBoost', 12999.99, 100),
('Puma Sports T-shirt', 899.99, 300),
('Reebok Running Shoes', 4999.99, 150),
('Philips Air Fryer', 7999.99, 130),
('Dyson V11 Vacuum Cleaner', 39999.99, 50),
('Xiaomi Mi 10i', 20999.99, 200),
('Vivo V23 Pro', 29999.99, 100),
('Oppo Reno 7', 27999.99, 120),
('Bajaj Mixer Grinder', 3499.99, 200),
('Panasonic Smart AC', 45999.99, 40),
('KitchenAid Stand Mixer', 19999.99, 60),
('Tata Tea Gold', 349.99, 500),
('Nescafe Classic Coffee', 299.99, 400),
('Pepsi 1L Bottle', 50.00, 1000),
('Coca Cola 1L Bottle', 50.00, 1000);

-- Step 11: Create a shopping cart for a customer
INSERT INTO cart (customer_id, total) VALUES (1, 0); -- Customer 1

-- Step 12: Add products to the shopping cart (10 products)
INSERT INTO cart_item (cart_id, product_id, quantity) VALUES
(1, 1, 2), -- 2 Samsung Galaxy A54
(1, 2, 3), -- 3 Apple iPhone 14
(1, 3, 1), -- 1 OnePlus 11
(1, 4, 4), -- 4 Realme Narzo 50
(1, 5, 5); -- 5 Xiaomi Redmi Note 12

-- Step 13: Update the value of the cart (adjust total) based on cart items and product prices
UPDATE cart
SET total = (
    SELECT SUM(ci.quantity * p.price)
    FROM cart_item ci
    JOIN product p ON ci.product_id = p.id
    WHERE ci.cart_id = cart.id
)
WHERE id = 1;

-- Step 14: Add more products to the cart (another 5 products)
INSERT INTO cart_item (cart_id, product_id, quantity) VALUES
(1, 1, 2), -- 2 Samsung Galaxy A54
(1, 2, 3), -- 3 Apple iPhone 14
(1, 3, 1), -- 1 OnePlus 11
(1, 4, 4), -- 4 Realme Narzo 50
(1, 5, 5); -- 5 Xiaomi Redmi Note 12

-- Step 15: Update the value of the cart again (adjust total) based on new items added
UPDATE cart
SET total = total + (
    SELECT SUM(ci.quantity * p.price)
    FROM cart_item ci
    JOIN product p ON ci.product_id = p.id
    WHERE ci.cart_id = cart.id
)
WHERE id = 1;

-- Step 16: Delete some products from the cart (5 products)
DELETE FROM cart_item WHERE id IN (1, 2, 3, 4, 5); -- Deleting products

-- Step 17: Create a customer order (for customer 1)
INSERT INTO customer_order (customer_id, total) VALUES (1, 0);

-- Step 18: Add more products to the order (5 products)
INSERT INTO order_item (order_id, product_id, quantity) VALUES
(1, 1, 2), -- 2 Samsung Galaxy A54
(1, 2, 3), -- 3 Apple iPhone 14
(1, 3, 1), -- 1 OnePlus 11
(1, 4, 4), -- 4 Realme Narzo 50
(1, 5, 5); -- 5 Xiaomi Redmi Note 12

-- Step 19: Reduce the stock quantity of products
UPDATE product SET stock_quantity = stock_quantity - 2 WHERE id = 1; -- Samsung Galaxy A54
UPDATE product SET stock_quantity = stock_quantity - 3 WHERE id = 2; -- Apple iPhone 14
UPDATE product SET stock_quantity = stock_quantity - 1 WHERE id = 3; -- OnePlus 11
UPDATE product SET stock_quantity = stock_quantity - 4 WHERE id = 4; -- Realme Narzo 50
UPDATE product SET stock_quantity = stock_quantity - 5 WHERE id = 5; -- Xiaomi Redmi Note 12

-- Step 20: Add more products to the order (5 products)
INSERT INTO order_item (order_id, product_id, quantity) VALUES
(1, 1, 2), -- 2 Samsung Galaxy A54
(1, 2, 3), -- 3 Apple iPhone 14
(1, 3, 1), -- 1 OnePlus 11
(1, 4, 4), -- 4 Realme Narzo 50
(1, 5, 5); -- 5 Xiaomi Redmi Note 12

-- Step 21: Update the stock quantity again (increase stock for the next operation)
UPDATE product SET stock_quantity = stock_quantity + 2 WHERE id = 1; -- Samsung Galaxy A54
UPDATE product SET stock_quantity = stock_quantity + 3 WHERE id = 2; -- Apple iPhone 14
UPDATE product SET stock_quantity = stock_quantity + 1 WHERE id = 3; -- OnePlus 11
UPDATE product SET stock_quantity = stock_quantity + 4 WHERE id = 4; -- Realme Narzo 50
UPDATE product SET stock_quantity = stock_quantity + 5 WHERE id = 5; -- Xiaomi Redmi Note 12


