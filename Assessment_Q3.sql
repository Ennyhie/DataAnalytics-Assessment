-- Selecting the needed data from two different tables and combining them
SELECT 
    savings_id AS plan_id,
    owner_id,
    'Savings' AS account_type,
    transaction_date AS last_transaction_date,
    DATEDIFF(CURDATE(), transaction_date) AS inactivity_days
FROM 
    cowrywise.savings_savingsaccount
WHERE 
    transaction_date IS NULL 
    OR transaction_date < CURDATE() - INTERVAL 365 DAY

UNION ALL

SELECT 
	id AS plan_id,
	owner_id,
    'Investment' AS account_type,
    last_charge_date AS last_transaction_date,
    DATEDIFF(CURDATE(), last_charge_date) AS inactivity_days
FROM 
    cowrywise.plans_plan
WHERE 
    last_charge_date IS NULL 
    OR last_charge_date < CURDATE() - INTERVAL 365 DAY;

