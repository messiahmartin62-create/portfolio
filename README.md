# Data Analyst Portfolio

**[View the live portfolio site →](https://messiahmartin62-create.github.io/portfolio/)** (charts, descriptions, and direct links to each report and workbook — no need to dig through folders)

Seven end-to-end analyses across three tools. Four are built twice — once as an Excel
workbook (pivot tables, live formulas, charts) and once as an R Markdown report (dplyr +
ggplot2). Two are SQL projects: real datasets normalized into relational SQLite databases and
queried with joins, CTEs, and window functions. The seventh is an econometrics project: an OLS
wage regression with hand-derived robust standard errors and formal hypothesis testing.

Also: **[AI & Automation](#ai--automation)**, five systems I designed and built with AI coding agents, including a
multi-agent content team, a workflow app and an LLM council.

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

## AI & Automation

Software I design and direct, built with AI coding agents (Claude Code): I write the specs and safety rules, review
every change, and test it in real use. These run my own content work every day. Each folder is a case study with an
architecture diagram; **the source code is private and available on request.**

- **[Warehouse](ai-automation/warehouse/)** — a local-first Node.js + SQLite app that runs my content workflow:
  it time-blocks my week, manages my video idea pipeline and recording days, and syncs confirmed days to Google
  Calendar. Its Roundtable gives me one place to direct five Claude Code agents and an LLM council, each with
  scoped permissions. 207 automated tests.

- **[Creator Workflow HQ](ai-automation/creator-workflow-hq/)** — a team of AI agents on Claude Code that mine
  YouTube for tips, write scripts in my voice, edit raw clips into drafts (Python engines over ffmpeg, WhisperX and
  Remotion) and audit the account. Each agent learns into its own memory, runs on a schedule, and has
  least-privilege permissions so outside content can't take it over.

- **[LLM Council](ai-automation/llm-council/)** — a multi-agent decision system: five AI advisors with opposing
  roles answer independently, review each other anonymously, and a Chairman turns it into a verdict with next steps
  that become hand-offs to other agents. Scored against written evaluation criteria and test cases.

- **[Motion Studio](ai-automation/motion-studio/)** — a Remotion (React + TypeScript) library of on-brand motion
  graphics timed to my speech, rendered as transparent ProRes 4444 video and composited onto edits automatically by
  my video-editing agent.

- **[Game Show Overlays for OBS](ai-automation/family-feud-obs/)** — two fan-made, browser-based game shows for
  live streams (inspired by Family Feud and Wheel of Fortune): a keyboard-driven control panel and a TV-style board
  synced across windows with no server, spreadsheet question packs parsed in the browser, and a full rules engine.

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

AI & Automation: Claude Code (multi-agent systems, skills, scoped permissions) · Node.js · SQLite · Python ·
ffmpeg / WhisperX · Remotion (React + TypeScript) · JavaScript / HTML / CSS
