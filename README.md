# eurusd-volatility-analysis
`Volatility analysis &amp; GARCH forecasting for EUR/USD in R`


OVERVIEW
A compact R project that:
Fetches 2 years of daily EUR/USD OHLC data from Yahoo Finance
Computes 10-day rolling realized volatility
Calculates Parkinson and Garman–Klass high–low volatility estimators
Fits a GARCH(1,1) model and produces a one-day ahead volatility forecast
Visualizes all measures in a publication-quality chart

Requirements
R (≥4.0)

The following R packages were used:
quantmod
TTR
rugarch
tidyverse
lubridate


RESULTS
After running the analysis script, you will see:
A combined time‑series chart comparing:
10‑day rolling realized volatility
Parkinson high–low estimator
Garman–Klass high–low estimator
A console output line with the one‑day‑ahead GARCH(1,1) volatility forecast, for example:
GARCH (1, 1) 1-day ahead sigma: 0.006192

PLOT
![dailyvoleurusd](https://github.com/user-attachments/assets/8d9586c3-a1e3-4e56-a899-87824ddbb7ab)



POTENTIAL ISSUES WITH PROJECT
Data source reliability: Yahoo Finance data may have occasional gaps or adjustments that can affect volatility calculations. Always verify with alternative data providers if precision is critical.

Model assumptions: The GARCH(1,1) model assumes normally-distributed residuals and constant parameters, which may not hold during market stress or structural breaks.

Rolling window choice: The 10-day window for realized volatility is arbitrary; different window lengths can produce materially different results.

High–low estimators limitations: Parkinson and Garman–Klass ignore opening jumps and assume continuous trading; actual FX markets may exhibit overnight gaps or low liquidity periods.
