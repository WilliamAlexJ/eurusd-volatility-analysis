# FX Volatility Analysis for EUR/USD — NA cleanup + Parkinson/Garman–Klass + GARCH
pkgs <- c(
  "quantmod",   
  "TTR",        
  "rugarch",    
  "tidyverse",  
  "lubridate"   
)
install.packages(setdiff(pkgs, installed.packages()[, "Package"]))
lapply(pkgs, library, character.only = TRUE)

#Download 2 years of daily EUR/USD from Yahoo
fx_daily <- getSymbols(
  "EURUSD=X", 
  src         = "yahoo",
  from        = Sys.Date() - 365*2,
  to          = Sys.Date(),
  auto.assign = FALSE
)

#Clean out any rows with missing OHLC values
fx_clean <- fx_daily[complete.cases(fx_daily), ]

#Compute daily log‐returns and 10‐day rolling realized vol
daily_ret <- dailyReturn(Cl(fx_clean), type = "log")

roll_sd  <- runSD(daily_ret, n = 10)
roll_vol <- roll_sd * sqrt(252)

#Parkinson & Garman–Klass estimators
# Parkinson: needs High, Low, AND Close
park_vol <- volatility(
  HLC(fx_clean),    # High–Low–Close
  n    = 1,
  calc = "parkinson"
)

#Garman–Klass: Open, High, Low, Close
gk_vol <- volatility(
  cbind(Op(fx_clean), HLC(fx_clean)),
  n    = 1,
  calc = "garman"
)

#Combine into one data‐frame and plot
df <- tibble(
  date       = index(daily_ret),
  rolling10d = coredata(roll_vol),
  parkinson  = coredata(park_vol),
  garman     = coredata(gk_vol)
) %>%
  pivot_longer(-date, names_to = "series", values_to = "vol") %>%
  filter(!is.na(vol))

ggplot(df, aes(x = date, y = vol, color = series)) +
  geom_line(size = 0.8) +
  labs(
    title    = "EUR/USD Daily Volatility Measures",
    subtitle = "10-day Rolling vs. Parkinson vs. Garman–Klass",
    x        = "Date",
    y        = "Volatility"
  ) +
  theme_minimal()

#Fit GARCH(1,1) & one-day-ahead forecast
spec      <- ugarchspec(
  variance.model     = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model         = list(armaOrder   = c(0, 0), include.mean = TRUE),
  distribution.model = "norm"
)
garch_fit <- ugarchfit(spec, daily_ret)
garch_fc  <- ugarchforecast(garch_fit, n.ahead = 1)
sigma1d   <- sigma(garch_fc)

cat("GARCH(1,1) 1-day ahead σ:", round(sigma1d, 6), "\n")
