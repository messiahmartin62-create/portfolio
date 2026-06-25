# Data Analyst Portfolio

**[View the live portfolio site →](https://messiahmartin62-create.github.io/portfolio/)** (charts, descriptions, and direct links to each report and workbook — no need to dig through folders)

Seven end-to-end analyses across three tools. Four are built twice — once as an Excel
workbook (pivot tables, live formulas, charts) and once as an R Markdown report (dplyr +
ggplot2). Two are SQL projects: real datasets normalized into relational SQLite databases and
queried with joins, CTEs, and window functions. The seventh is an econometrics project: an OLS
wage regression with hand-derived robust standard errors and formal hypothesis testing.

## Projects

- **[NBA Stat Projections](nba/)** — per-game scoring/rebounding/assist rates
  by position and season (2008–2017), with featured-player trend lines.
  Demonstrates COUNTIFS/AVERAGEIFS-style aggregation and VLOOKUP-style
  position lookups in Excel; `dplyr::group_by()/summarise()` and `recode()`
  in R.

- **[NFL Betting Trends](nfl/)** — against-the-spread and over/under outcomes
  for 2,136 games (2010–2017), broken out by favorite team and spread size.
  Demonstrates nested-IF outcome classification in Excel; `case_when()` in R.

- **[Video Game Sales](video-games/)** — global sales vs. critic/user
  reception across 16,717 titles, by genre, platform, publisher, and release
  year. Demonstrates SUMIFS/multi-criteria aggregation in Excel; `dplyr`
  grouped aggregation and `ggplot2` scatter/trend charts in R.

- **[Finance & Supply Chain](finance/)** — profitability and late-delivery
  risk across 9,000 order lines, with department-group rollups and a
  rule-based risk flag (loss-making, late-risk, low-margin, healthy).
  Demonstrates MAXIFS+SUMPRODUCT-style row-finding and multi-tier IF logic in
  Excel; `case_when()` priority logic in R.

- **[Book Ratings Analysis (SQL)](book-ratings/)** — 900K real Goodreads
  ratings across 10,000 books (sampled from [goodbooks-10k](https://github.com/zygmuntz/goodbooks-10k)),
  loaded into a 4-table relational SQLite database. Six queries covering
  joins, multi-level CTEs, window functions (`RANK() OVER`, rolling `AVG()
  OVER`), and a manual variance calculation — finding the highest-rated,
  most polarizing, and most divisive books, and how individual raters skew
  the data.

- **[Online Retail Analysis (SQL)](online-retail/)** — 541,909 invoice line
  items from a real UK online gift retailer (UCI "Online Retail" dataset),
  normalized by hand from one flat file into a 4-table relational schema
  (customers/products/orders/order_items). Six queries covering CTEs,
  window functions (`LAG()`, running `SUM() OVER`), RFM customer
  segmentation, and returns analysis.

- **[Wage Regression & the Gender Pay Gap (Econometrics)](wage-regression/)** —
  Mincer earnings regression on 526 workers from the 1976 CPS (Wooldridge's
  canonical `wage1` dataset). Three nested OLS models (human capital →
  demographics → occupation/region), an experience-turning-point calculation,
  a Breusch-Pagan heteroskedasticity test, hand-derived White/HC1
  robust standard errors (matrix algebra, no `sandwich`/`lmtest` package),
  nested F-tests, residual diagnostics, and an honest causality/
  omitted-variable-bias discussion. The headline finding: the gender wage
  gap barely narrows after controlling for occupation and region — most of
  it persists within job categories, not because of how men and women sort
  into them.

## How each project folder is organized

**Excel + R projects** (`nba/`, `nfl/`, `video-games/`, `finance/`):
- `*_Portfolio.xlsx` — the Excel workbook (open in Excel or LibreOffice Calc)
- `*_analysis.Rmd` — the R Markdown source (open in RStudio to re-run)
- `*_analysis.html` — the rendered report, viewable in any browser with no
  R installation required

**SQL projects** (`book-ratings/`, `online-retail/`):
- `*.db` — the SQLite database (open with any SQLite client, e.g. `sqlite3`
  or DB Browser for SQLite)
- `schema.sql` — table definitions, with notes on data cleaning/normalization
  decisions
- `queries.sql` — the six business-question queries, commented
- `*_analysis.html` — the rendered report: each query, its result, and a
  written insight grounded in the actual output

**Econometrics project** (`wage-regression/`):
- `wage1.csv` — the raw dataset, included so the `.Rmd` runs end-to-end with
  no external dependency
- `wage-regression_analysis.Rmd` — the R Markdown source (open in RStudio to
  re-run the full regression pipeline)
- `wage-regression_analysis.html` — the rendered report, viewable in any
  browser

## Stack

Excel (formulas, pivot tables, charts) · R (dplyr, ggplot2, rmarkdown/knitr) · SQL (SQLite) ·
Applied econometrics (OLS, robust standard errors, hypothesis testing)
