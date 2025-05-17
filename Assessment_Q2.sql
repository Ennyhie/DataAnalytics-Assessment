-- Created a CTE (Common Temporary Table) to extract the specific montly transaction
WITH monthly_transactions AS (
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS trans_month,
        COUNT(*) AS monthly_count
    FROM
        cowrywise.savings_savingsaccount
    GROUP BY
        owner_id, trans_month
),
-- Created a CTE to extract the average transaction per customuser
avg_txns_per_user AS (
    SELECT
        owner_id,
        AVG(monthly_count) AS avg_txns_per_month
    FROM
        monthly_transactions
    GROUP BY
        owner_id
),
-- Created a CTE to extract the average transaction in frequency category
categorized_users AS (
    SELECT
        owner_id,
        ROUND(avg_txns_per_month, 2) AS avg_txns_per_month,
        CASE 
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        avg_txns_per_user
)
-- The Select query to display the data needed
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transcations_per_customer_per_month
FROM
    categorized_users
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

