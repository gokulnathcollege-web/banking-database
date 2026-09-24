-- ============================================
-- BANKING DATABASE PROJECT
-- ============================================

CREATE DATABASE IF NOT EXISTS banking_db;
USE banking_db;

-- ============================================
-- 1. CUSTOMER TABLE
-- ============================================

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200)
);

-- ============================================
-- 2. ACCOUNT TYPE TABLE
-- ============================================

CREATE TABLE AccountType (
    account_type_id INT PRIMARY KEY,
    account_type_name VARCHAR(50) NOT NULL UNIQUE
);

-- ============================================
-- 3. ACCOUNT TABLE
-- ============================================

CREATE TABLE Account (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    account_type_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    opening_date DATE NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    FOREIGN KEY (account_type_id)
        REFERENCES AccountType(account_type_id)
);

-- ============================================
-- 4. TRANSACTION TABLE
-- ============================================

CREATE TABLE `Transaction` (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_date DATE NOT NULL,
    description VARCHAR(200),

    FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
);

-- ============================================
-- INSERT ACCOUNT TYPES
-- ============================================

INSERT INTO AccountType
(account_type_id, account_type_name)
VALUES
(1, 'Savings'),
(2, 'Current');

-- ============================================
-- INSERT CUSTOMERS
-- ============================================

INSERT INTO Customer
(customer_name, phone, email, address)
VALUES
('Arun Kumar S', '9876543210', 'arun@gmail.com', 'Gudalur'),
('Priya Devi', '9876543211', 'priya@gmail.com', 'Chennai'),
('Rahul Raj', '9876543212', 'rahul@gmail.com', 'Coimbatore'),
('Karthik M', '9876543213', 'karthik@gmail.com', 'Ooty'),
('Anitha R', '9876543214', 'anitha@gmail.com', 'Mysore');

-- ============================================
-- INSERT ACCOUNTS
-- ============================================

INSERT INTO Account
(customer_id, account_type_id, account_number, opening_date, balance)
VALUES
(1, 1, 'SB100001', '2026-09-01', 12000.00),
(2, 1, 'SB100002', '2026-09-02', 20000.00),
(3, 2, 'CA100003', '2026-09-03', 8000.00),
(4, 1, 'SB100004', '2026-09-04', 15000.00),
(5, 2, 'CA100005', '2026-09-05', 25000.00);

-- ============================================
-- INSERT TRANSACTIONS
-- ============================================

INSERT INTO `Transaction`
(account_id, transaction_type, amount, transaction_date, description)
VALUES
(1, 'Deposit', 10000.00, '2026-09-05', 'Cash deposit'),
(1, 'Withdrawal', 3000.00, '2026-09-08', 'ATM withdrawal'),
(2, 'Deposit', 25000.00, '2026-09-10', 'Salary credit'),
(2, 'Withdrawal', 5000.00, '2026-09-12', 'Cash withdrawal'),
(3, 'Deposit', 8000.00, '2026-09-15', 'Cash deposit'),
(4, 'Deposit', 15000.00, '2026-09-16', 'Online transfer'),
(5, 'Deposit', 30000.00, '2026-09-17', 'Business deposit'),
(5, 'Withdrawal', 5000.00, '2026-09-18', 'ATM withdrawal');

-- ============================================
-- BASIC SELECT
-- ============================================

SELECT * FROM Customer;

SELECT * FROM AccountType;

SELECT * FROM Account;

SELECT * FROM `Transaction`;

-- ============================================
-- CRUD OPERATIONS
-- ============================================

-- INSERT
INSERT INTO Customer
(customer_name, phone, email, address)
VALUES
('Suresh Kumar', '9876543215', 'suresh@gmail.com', 'Bangalore');

-- SELECT
SELECT * FROM Customer;

-- UPDATE
UPDATE Account
SET balance = balance + 5000
WHERE account_id = 1;

-- DELETE
DELETE FROM `Transaction`
WHERE transaction_id = 8;

-- ============================================
-- FILTERING
-- ============================================

-- Deposit transactions
SELECT *
FROM `Transaction`
WHERE transaction_type = 'Deposit';

-- Customers whose name starts with A
SELECT *
FROM Customer
WHERE customer_name LIKE 'A%';

-- Transactions between 1000 and 10000
SELECT *
FROM `Transaction`
WHERE amount BETWEEN 1000 AND 10000;

-- ============================================
-- SORTING
-- ============================================

SELECT *
FROM Account
ORDER BY balance DESC;

-- ============================================
-- AGGREGATE FUNCTIONS
-- ============================================

SELECT
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount,
    MAX(amount) AS maximum_amount,
    MIN(amount) AS minimum_amount
FROM `Transaction`;

-- ============================================
-- GROUP BY
-- ============================================

SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM `Transaction`
GROUP BY transaction_type;

-- ============================================
-- INNER JOIN
-- ============================================

SELECT
    c.customer_name,
    a.account_number,
    at.account_type_name,
    t.transaction_type,
    t.amount,
    t.transaction_date
FROM Customer c
INNER JOIN Account a
    ON c.customer_id = a.customer_id
INNER JOIN AccountType at
    ON a.account_type_id = at.account_type_id
INNER JOIN `Transaction` t
    ON a.account_id = t.account_id;

-- ============================================
-- CUSTOMER + ACCOUNT DETAILS
-- ============================================

SELECT
    c.customer_name,
    c.phone,
    a.account_number,
    at.account_type_name,
    a.balance
FROM Customer c
INNER JOIN Account a
    ON c.customer_id = a.customer_id
INNER JOIN AccountType at
    ON a.account_type_id = at.account_type_id;

-- ============================================
-- TOTAL DEPOSIT
-- ============================================

SELECT
    SUM(amount) AS total_deposit
FROM `Transaction`
WHERE transaction_type = 'Deposit';

-- ============================================
-- TOTAL WITHDRAWAL
-- ============================================

SELECT
    SUM(amount) AS total_withdrawal
FROM `Transaction`
WHERE transaction_type = 'Withdrawal';

-- ============================================
-- TRANSACTION HISTORY FOR ACCOUNT 1
-- ============================================

SELECT *
FROM `Transaction`
WHERE account_id = 1
ORDER BY transaction_date;