-- ============================================================
-- Goodreads Book Ratings -- schema
-- Source: goodbooks-10k (github.com/zygmuntz/goodbooks-10k)
-- Real Goodreads ratings data, not a synthetic tutorial DB.
-- ratings.csv was sampled from ~6M rows down to 900K (seed=42)
-- to keep the .db file a reasonable size for a GitHub repo;
-- book_tags was trimmed to each book's top 20 tags by count.
-- Everything else (books, tags) is the full original data.
-- ============================================================

CREATE TABLE books (
    book_id                     INTEGER PRIMARY KEY,  -- 1..10000, contiguous
    goodreads_book_id           INTEGER,               -- real Goodreads ID, used to join book_tags
    authors                     TEXT,
    original_publication_year   REAL,
    original_title               TEXT,
    title                        TEXT,
    language_code                TEXT,
    average_rating                REAL,   -- pre-computed by Goodreads on the full platform (not from our `ratings` sample)
    ratings_count                  INTEGER,
    work_ratings_count             INTEGER,
    ratings_1                      INTEGER,
    ratings_2                      INTEGER,
    ratings_3                      INTEGER,
    ratings_4                      INTEGER,
    ratings_5                      INTEGER
);

CREATE TABLE ratings (
    user_id     INTEGER,   -- 1..53424, contiguous
    book_id     INTEGER,   -- FK -> books.book_id
    rating      INTEGER    -- 1..5
);

CREATE TABLE tags (
    tag_id      INTEGER PRIMARY KEY,
    tag_name    TEXT
);

CREATE TABLE book_tags (
    goodreads_book_id  INTEGER,  -- FK -> books.goodreads_book_id (NOT book_id)
    tag_id              INTEGER,  -- FK -> tags.tag_id
    count                INTEGER  -- how many users applied this tag/shelf
);

CREATE INDEX idx_ratings_book ON ratings(book_id);
CREATE INDEX idx_ratings_user ON ratings(user_id);
CREATE INDEX idx_booktags_gbid ON book_tags(goodreads_book_id);
CREATE INDEX idx_books_gbid ON books(goodreads_book_id);
