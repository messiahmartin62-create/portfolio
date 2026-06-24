# Data Analyst Portfolio

Four end-to-end analyses, each built twice: once as an Excel workbook (pivot
tables, live formulas, charts) and once as an R Markdown report (dplyr +
ggplot2, rendered to HTML). Same underlying public datasets and the same
analytical logic in both versions — the Excel files show spreadsheet fluency,
the R files show the same thinking in a scripted, reproducible language.

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

## How each project folder is organized

Each folder contains:
- `*_Portfolio.xlsx` — the Excel workbook (open in Excel or LibreOffice Calc)
- `*_analysis.Rmd` — the R Markdown source (open in RStudio to re-run)
- `*_analysis.html` — the rendered report, viewable in any browser with no
  R installation required

## Stack

Excel (formulas, pivot tables, charts) · R (dplyr, ggplot2, rmarkdown/knitr)
