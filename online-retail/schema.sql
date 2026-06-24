-- ============================================================
-- UK Online Retail Transactions -- schema
-- Source: UCI Machine Learning Repository, "Online Retail"
-- (real invoice-level transactions, Dec 2010-Dec 2011, UK-based
-- online gift retailer). The original file is one flat table of
-- 541,909 line items -- I normalized it into 4 tables myself.
--
-- Cleaning decisions made during normalization:
--  - ~25% of rows have no CustomerID (guest/unrecorded checkouts).
--    Those rows still appear in orders/order_items with a NULL
--    CustomerID rather than being dropped.
--  - 8 of 4,372 customers had more than one Country value across
--    their orders; each customer was assigned their most frequent
--    country.
--  - 650 of 4,070 stock codes had more than one Description on
--    file (typos/case differences); each was assigned its most
--    frequent description. Codes with no description at all
--    (e.g. "DOT", "POST" non-product line items) are labeled
--    'UNKNOWN' rather than dropped.
--  - Cancelled orders (InvoiceNo starting with "C") are kept and
--    flagged via IsCancelled, not deleted -- they're real signal
--    for returns analysis.
-- ============================================================

CREATE TABLE customers (
    CustomerID  INTEGER PRIMARY KEY,
    Country     TEXT
);

CREATE TABLE products (
    StockCode   TEXT PRIMARY KEY,
    Description TEXT
);

CREATE TABLE orders (
    InvoiceNo    TEXT PRIMARY KEY,
    CustomerID   INTEGER,   -- FK -> customers.CustomerID, NULL = guest checkout
    InvoiceDate  TIMESTAMP,
    Country      TEXT,
    IsCancelled  INTEGER    -- 1 if InvoiceNo starts with 'C'
);

CREATE TABLE order_items (
    InvoiceNo  TEXT,      -- FK -> orders.InvoiceNo
    StockCode  TEXT,      -- FK -> products.StockCode
    Quantity   INTEGER,   -- negative on cancelled/returned lines
    UnitPrice  REAL
);

CREATE INDEX idx_orders_cust ON orders(CustomerID);
CREATE INDEX idx_items_invoice ON order_items(InvoiceNo);
CREATE INDEX idx_items_stock ON order_items(StockCode);
CREATE INDEX idx_orders_date ON orders(InvoiceDate);
