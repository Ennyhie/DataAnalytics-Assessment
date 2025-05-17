-- Create temporary table due to long loading period
-- Temporary table for savings
CREATE TEMPORARY TABLE temp_savings_summary AS
SELECT 
    owner_id, 
    COUNT(*) AS savings_count, 
    SUM(amount) AS total_savings_amount
FROM 
    cowrywise.savings_savingsaccount
GROUP BY 
    owner_id;

-- temporary table for Investment plan
CREATE TEMPORARY TABLE temp_plans_summary AS
SELECT 
    owner_id, 
    COUNT(*) AS plan_count, 
    SUM(amount) AS total_plan_amount
FROM 
    cowrywise.plans_plan
GROUP BY 
    owner_id;
-- select statement to fetch result of Q1 from the Database
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    p.plan_count AS investment_count,
    (s.total_savings_amount + p.total_plan_amount) AS total_deposit
FROM 
    cowrywise.users_customuser u
JOIN (
    SELECT 
        owner_id, 
        COUNT(*) AS savings_count, 
        SUM(amount) AS total_savings_amount
    FROM 
        cowrywise.savings_savingsaccount
    GROUP BY 
    
        owner_id
) s ON u.id = s.owner_id
JOIN (
    SELECT 
        owner_id, 
        COUNT(*) AS plan_count, 
        SUM(amount) AS total_plan_amount
    FROM 
        cowrywise.plans_plan
    GROUP BY 
        owner_id
) p ON u.id = p.owner_id
WHERE 
    CONCAT(u.first_name, ' ', u.last_name) IS NOT NULL 
    AND CONCAT(u.first_name, ' ', u.last_name) != ''
    AND s.savings_count > 0 
    AND p.plan_count > 0
    AND s.total_savings_amount > 0
    AND p.total_plan_amount > 0
ORDER BY 
     total_deposit desc;


