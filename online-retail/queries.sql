-- ============================================================
-- UK Online Retail Transactions -- Analysis
-- Source: UCI "Online Retail" dataset, normalized into
-- customers / products / orders / order_items (see schema.sql).
-- Revenue = Quantity * UnitPrice, summed across order_items,
-- this is net of returns since returned lines carry negative
-- Quantity (see schema notes on IsCancelled).
-- ============================================================

-- Q1. Monthly revenue with month-over-month % change.
-- CTE for the monthly rollup, LAG() window function for the
-- prior month's value.
WITH monthly AS (
    SELECT
        strftime('%Y-%m', o.InvoiceDate)            AS month,
        ROUND(SUM(oi.Quantity * oi.UnitPrice), 2)    AS revenue
    FROM orders o
    JOIN order_items oi ON oi.InvoiceNo = o.InvoiceNo
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)                                       AS prev_month_revenue,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
          / LAG(revenue) OVER (ORDER BY month), 1)                          AS pct_change
FROM monthly
ORDER BY month;

-- Q2. Top 10 products by revenue, with running cumulative % of
-- total revenue (a quick Pareto / 80-20 check). Window SUM() OVER
-- an ORDER BY for the running total.
WITH product_rev AS (
    SELECT
        p.StockCode,
        p.Description,
        ROUND(SUM(oi.Quantity * oi.UnitPrice), 2) AS revenue
    FROM order_items oi
    JOIN products p ON p.StockCode = oi.StockCode
    -- exclude administrative line items (postage, manual adjustments,
    -- bank charges, etc.) that aren't real products -- otherwise they
    -- dominate a "top products" list and make it meaningless
    WHERE p.StockCode NOT IN ('POST','DOT','M','m','C2','D','S','BANK CHARGES','AMAZONFEE','CRUK')
    GROUP BY p.StockCode
),
totals AS (
    SELECT SUM(revenue) AS grand_total FROM product_rev
)
SELECT
    pr.Description,
    pr.revenue,
    ROUND(100.0 * SUM(pr.revenue) OVER (ORDER BY pr.revenue DESC) / t.grand_total, 1) AS cumulative_pct_of_total
FROM product_rev pr
CROSS JOIN totals t
ORDER BY pr.revenue DESC
LIMIT 10;

-- Q3. Simplified RFM customer segmentation.
-- Recency = days since last order (relative to the dataset's max
-- date, since this is historical data, not live). Frequency =
-- distinct orders. Monetary = total net spend.
-- CTE chain + CASE-based tiering.
WITH cust_orders AS (
    SELECT
        o.CustomerID,
        COUNT(DISTINCT o.InvoiceNo)                            AS frequency,
        SUM(oi.Quantity * oi.UnitPrice)                         AS monetary,
        MAX(o.InvoiceDate)                                      AS last_order
    FROM orders o
    JOIN order_items oi ON oi.InvoiceNo = o.InvoiceNo
    WHERE o.CustomerID IS NOT NULL
    GROUP BY o.CustomerID
),
rfm AS (
    SELECT
        CustomerID,
        frequency,
        ROUND(monetary, 2)                                                          AS monetary,
        CAST(julianday((SELECT MAX(InvoiceDate) FROM orders)) - julianday(last_order) AS INT) AS recency_days
    FROM cust_orders
)
SELECT
    CustomerID,
    frequency,
    monetary,
    recency_days,
    CASE
        WHEN recency_days <= 30 AND frequency >= 5  THEN 'VIP'
        WHEN recency_days <= 90 AND frequency >= 2  THEN 'Active'
        WHEN recency_days > 180                      THEN 'Lost'
        ELSE 'At Risk'
    END AS segment
FROM rfm
ORDER BY monetary DESC
LIMIT 15;

-- Q4. Revenue and average order value by country, ranked.
-- 3-way JOIN (orders -> order_items, orders -> customers)
-- + GROUP BY + RANK().
SELECT
    o.Country,
    COUNT(DISTINCT o.InvoiceNo)                                  AS n_orders,
    ROUND(SUM(oi.Quantity * oi.UnitPrice), 2)                    AS revenue,
    ROUND(SUM(oi.Quantity * oi.UnitPrice) * 1.0
          / COUNT(DISTINCT o.InvoiceNo), 2)                       AS avg_order_value,
    RANK() OVER (ORDER BY SUM(oi.Quantity * oi.UnitPrice) DESC)   AS revenue_rank
FROM orders o
JOIN order_items oi ON oi.InvoiceNo = o.InvoiceNo
WHERE o.IsCancelled = 0
GROUP BY o.Country
ORDER BY revenue_rank
LIMIT 15;

-- Q5. Repeat vs. one-time customers: how many of each, and how
-- much revenue each group is responsible for.
-- Subquery to classify, then aggregate.
WITH cust_freq AS (
    SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS n_orders
    FROM orders
    WHERE CustomerID IS NOT NULL AND IsCancelled = 0
    GROUP BY CustomerID
)
SELECT
    CASE WHEN cf.n_orders > 1 THEN 'Repeat customer' ELSE 'One-time customer' END AS customer_type,
    COUNT(DISTINCT cf.CustomerID)                                                          AS n_customers,
    ROUND(SUM(oi.Quantity * oi.UnitPrice), 2)                                              AS total_revenue,
    ROUND(SUM(oi.Quantity * oi.UnitPrice) * 1.0 / COUNT(DISTINCT cf.CustomerID), 2)         AS avg_revenue_per_customer
FROM cust_freq cf
JOIN orders o ON o.CustomerID = cf.CustomerID AND o.IsCancelled = 0
JOIN order_items oi ON oi.InvoiceNo = o.InvoiceNo
GROUP BY customer_type;

-- Q6. Returns analysis: which products generate the most
-- returned value, and what share of their gross sales does
-- that represent? Two CTEs (gross sales, returns) joined
-- together -- faster and cleaner than a correlated subquery
-- per row, which is what this started as before it got
-- rewritten.
WITH gross AS (
    SELECT oi.StockCode, SUM(oi.Quantity * oi.UnitPrice) AS gross_sales
    FROM order_items oi
    JOIN orders o ON o.InvoiceNo = oi.InvoiceNo
    WHERE o.IsCancelled = 0
      AND oi.StockCode NOT IN ('POST','DOT','M','m','C2','D','S','BANK CHARGES','AMAZONFEE','CRUK')
    GROUP BY oi.StockCode
),
returns AS (
    SELECT oi.StockCode, -SUM(oi.Quantity * oi.UnitPrice) AS returned_value
    FROM order_items oi
    JOIN orders o ON o.InvoiceNo = oi.InvoiceNo
    WHERE o.IsCancelled = 1
      AND oi.StockCode NOT IN ('POST','DOT','M','m','C2','D','S','BANK CHARGES','AMAZONFEE','CRUK')
    GROUP BY oi.StockCode
)
SELECT
    p.Description,
    ROUND(r.returned_value, 2)                              AS returned_value,
    ROUND(g.gross_sales, 2)                                  AS gross_sales,
    ROUND(100.0 * r.returned_value / g.gross_sales, 1)       AS pct_of_gross_returned
FROM returns r
JOIN gross g ON g.StockCode = r.StockCode
JOIN products p ON p.StockCode = r.StockCode
WHERE g.gross_sales > 500
ORDER BY r.returned_value DESC
LIMIT 10;
