-- ============================================================
-- Goodreads Book Ratings Analysis
-- Source: goodbooks-10k (zygmuntz/goodbooks-10k on GitHub)
-- 10,000 books, ~6M real Goodreads ratings (900K sampled here
-- to keep the file size portfolio-friendly), plus tags/book_tags
-- for genre/shelf data.
-- ============================================================

-- Q1. Top 10 highest-rated books with a meaningful sample size.
-- Computed fresh from the ratings table (not the pre-baked
-- average_rating column) so the number is something I actually
-- derived, not something I copied from the source file.
SELECT
    b.title,
    b.authors,
    COUNT(*)                       AS n_ratings,
    ROUND(AVG(r.rating), 2)        AS avg_rating
FROM ratings r
JOIN books b ON b.book_id = r.book_id
GROUP BY b.book_id
HAVING COUNT(*) >= 200
ORDER BY avg_rating DESC, n_ratings DESC
LIMIT 10;

-- Q2. Most-used tags/shelves, joined across book_tags -> tags.
-- Top results mix real genres with generic shelves like "to-read" --
-- that's real-world data noise, not a bug, and it's called out in
-- the write-up.
SELECT
    t.tag_name,
    COUNT(DISTINCT bt.goodreads_book_id)   AS n_books_tagged,
    SUM(bt.count)                          AS total_tag_uses
FROM book_tags bt
JOIN tags t ON t.tag_id = bt.tag_id
GROUP BY t.tag_name
ORDER BY total_tag_uses DESC
LIMIT 15;

-- Q3. Top 3 books per publication decade by computed average rating.
-- CTE chain + RANK() window function PARTITIONed by decade.
WITH book_avg AS (
    SELECT book_id, COUNT(*) AS n_ratings, AVG(rating) AS avg_rating
    FROM ratings
    GROUP BY book_id
    HAVING COUNT(*) >= 100
),
decade_books AS (
    SELECT
        b.title,
        b.authors,
        (CAST(b.original_publication_year AS INT) / 10) * 10 AS decade,
        ba.avg_rating,
        ba.n_ratings
    FROM book_avg ba
    JOIN books b ON b.book_id = ba.book_id
    WHERE b.original_publication_year IS NOT NULL
),
ranked AS (
    SELECT
        decade,
        title,
        authors,
        ROUND(avg_rating, 2) AS avg_rating,
        n_ratings,
        RANK() OVER (PARTITION BY decade ORDER BY avg_rating DESC) AS rank_in_decade
    FROM decade_books
)
SELECT * FROM ranked
WHERE rank_in_decade <= 3
ORDER BY decade DESC, rank_in_decade;

-- Q4. Most polarizing books: high rating volume, high disagreement.
-- SQLite has no STDDEV(), so variance is computed manually from
-- E[x^2] - E[x]^2.
SELECT
    b.title,
    b.authors,
    COUNT(*)                                                            AS n_ratings,
    ROUND(AVG(r.rating), 2)                                             AS avg_rating,
    ROUND(SQRT(AVG(r.rating * r.rating) - AVG(r.rating) * AVG(r.rating)), 2) AS rating_stddev
FROM ratings r
JOIN books b ON b.book_id = r.book_id
GROUP BY b.book_id
HAVING COUNT(*) >= 300
ORDER BY rating_stddev DESC
LIMIT 10;

-- Q5. Power users vs. the global average -- who rates harsher or more
-- generously than everyone else. CTE + scalar subquery for the
-- global baseline.
WITH user_stats AS (
    SELECT user_id, COUNT(*) AS n_ratings, AVG(rating) AS user_avg
    FROM ratings
    GROUP BY user_id
    HAVING COUNT(*) >= 20
)
SELECT
    user_id,
    n_ratings,
    ROUND(user_avg, 2)                                          AS user_avg_rating,
    ROUND(user_avg - (SELECT AVG(rating) FROM ratings), 2)      AS diff_vs_global_avg
FROM user_stats
ORDER BY n_ratings DESC
LIMIT 10;

-- Q6. 5-year rolling average rating by publication year -- do older
-- or newer books trend better? CTE + window frame (ROWS BETWEEN).
WITH yearly AS (
    SELECT
        CAST(b.original_publication_year AS INT) AS pub_year,
        AVG(r.rating)                             AS avg_rating,
        COUNT(*)                                  AS n_ratings
    FROM ratings r
    JOIN books b ON b.book_id = r.book_id
    WHERE b.original_publication_year IS NOT NULL
      AND CAST(b.original_publication_year AS INT) BETWEEN 1980 AND 2017
    GROUP BY pub_year
)
SELECT
    pub_year,
    ROUND(avg_rating, 3)  AS avg_rating,
    n_ratings,
    ROUND(AVG(avg_rating) OVER (
        ORDER BY pub_year ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 3)                  AS rolling_5yr_avg
FROM yearly
ORDER BY pub_year;
