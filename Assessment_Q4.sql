SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- To obtain the tenure_months (difference between both dates)
    ROUND(TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()), 2) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    -- Formula for  Estimated CLV given
	ROUND((COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()), 0)) * 12 *(COUNT(s.id) * 0.001), 2) AS estimated_clv
FROM
    cowrywise.users_customuser AS u
JOIN
    cowrywise.savings_savingsaccount AS s 
ON s.owner_id = u.id
GROUP BY
    u.id
ORDER BY
    estimated_clv DESC;
