library(httr)
library(jsonlite)

get_response_content <- function(api_response) {
  httr::content(api_response,
                type = "text",
                encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE)
}


all_assets <- httr::GET("https://data.messari.io/api/v1/assets")

all_assets <- get_response_content(all_assets)


# Initialize new dataframe:
crypto_data <- data.frame(1:20)

#### FOR Loop: #### 
for (i in 1:20){
# Logic below can then be adapted to create iteration with purrr or for loop
crypto_data[i,'symbol'] <- all_assets$data[[i]]$symbol
crypto_data[i,'name'] <- all_assets$data[[i]]$name
# Market Data
crypto_data[i,'price_usd'] <- all_assets$data[[i]]$metrics$market_data$price_usd
crypto_data[i,'price_btc'] <- all_assets$data[[i]]$metrics$market_data$price_btc
# STEPS FAIL IF DON'T CHECK THEIR LENGTH FIRST:
if (length(all_assets$data[[i]]$metrics$market_data$volume_last_24_hours) > 0){
  crypto_data[i,'volume_last_24_hours'] <- all_assets$data[[i]]$metrics$market_data$volume_last_24_hours
}
if (length(all_assets$data[[i]]$metrics$market_data$real_volume_last_24_hours) > 0){
  crypto_data[i,'real_volume_last_24_hours'] <- all_assets$data[[i]]$metrics$market_data$real_volume_last_24_hour
}
# OHLCV 1 Hour
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$open) > 0){
  crypto_data[i,"ohlcv_1_hour_open"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$open
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$close) > 0){
  crypto_data[i,"ohlcv_1_hour_close"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$close
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$high) > 0){
  crypto_data[i,"ohlcv_1_hour_high"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$high
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$low) > 0){
  crypto_data[i,"ohlcv_1_hour_low"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$low
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$volume) > 0){
  crypto_data[i,"ohlcv_1_hour_volume"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_1_hour$volume
}
# OHLCV 24 Hour
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$open) > 0){
  crypto_data[i,"ohlcv_24_hour_open"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$open
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$close) > 0){
  crypto_data[i,"ohlcv_24_hour_close"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$close
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$high) > 0){
  crypto_data[i,"ohlcv_24_hour_high"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$high
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$low) > 0){
  crypto_data[i,"ohlcv_24_hour_low"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$low
}
if (length(all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$volume) > 0){
  crypto_data[i,"ohlcv_24_hour_volume"] <- all_assets$data[[i]]$metrics$market_data$ohlcv_last_24_hour$volume
}
# Market Cap
if (length(all_assets$data[[i]]$metrics$marketcap$current_marketcap_usd) > 0){
  crypto_data[i,"market_cap_usd"] <- all_assets$data[[i]]$metrics$marketcap$current_marketcap_usd
}
if (length(all_assets$data[[i]]$metrics$marketcap$y_2050_marketcap_usd) > 0){
  crypto_data[i,"y_2050_market_cap_usd"] <- all_assets$data[[i]]$metrics$marketcap$y_2050_marketcap_usd
}
if (length(all_assets$data[[i]]$metrics$marketcap$y_plusi0_marketcap_usd) > 0){
  crypto_data[i,"y_plusi0_market_cap_usd"] <- all_assets$data[[i]]$metrics$marketcap$y_plusi0_marketcap_usd
}
if (length(all_assets$data[[i]]$metrics$marketcap$liquid_marketcap_usd) > 0){
  crypto_data[i,"liquid_market_cap_usd"] <- all_assets$data[[i]]$metrics$marketcap$liquid_marketcap_usd
}
if (length(all_assets$data[[i]]$metrics$marketcap$volume_turnover_last_24_hours_percent) > 0){
  crypto_data[i,"volume_turnover_24_hours_percent"] <- all_assets$data[[i]]$metrics$marketcap$volume_turnover_last_24_hours_percent
}
# Supply
if (length(all_assets$data[[i]]$metrics$supply$y_2050) > 0){
  crypto_data[i,"supply_y_2050"] <- all_assets$data[[i]]$metrics$supply$y_2050
}
##### STOPPED HERE, KEEP GOING! #####

#ENTER THE REST HERE (only did first)
 
# Blockchain Stats 24 Hours
if (length(all_assets$data[[i]]$metrics$blockchain_stats_24_hours$transaction_volume) > 0){
  crypto_data[i,"transaction_volume_24_hours"] <- all_assets$data[[i]]$metrics$blockchain_stats_24_hours$transaction_volume
}
#ENTER THE REST HERE (only did first)
 
# Market Data Liquidity (this one is a bit weird careful with subsetting)
# if (length(all_assets$data[[i]]$metrics$market_data_liquidity$clearing_prices_to_sell[[i]]$amount_usd) > 0){
#   crypto_data[i,"clearning_prices_to_sell_amount_usd"] <- all_assets$data[[i]]$metrics$market_data_liquidity$clearing_prices_to_sell[[i]]$amount_usd
# }
#ENTER THE REST HERE (only did first)
 
# All Time High
if (length(all_assets$data[[i]]$metrics$all_time_high$price) > 0){
  crypto_data[i,"ath_price"] <- all_assets$data[[i]]$metrics$all_time_high$price
}
#ENTER THE REST HERE (only did first)

# Cycle Low
if (length(all_assets$data[[i]]$metrics$cycle_low$price) > 0){
  crypto_data[i,"cycle_low_price"] <- all_assets$data[[i]]$metrics$cycle_low$price
}
#ENTER THE REST HERE (only did first)
 
# Token Sale Stats
if (length(all_assets$data[[i]]$metrics$token_sale_stats$sale_proceeds_usd) > 0){
  crypto_data[i,"token_sale_proceeds_usd"] <- all_assets$data[[i]]$metrics$token_sale_stats$sale_proceeds_usd
}
#ENTER THE REST HERE (only did first)

# Staking Stats
if (length(all_assets$data[[i]]$metrics$staking_stats$staking_yield_percent) > 0){
  crypto_data[i,"staking_yield_percent"] <- all_assets$data[[i]]$metrics$staking_stats$staking_yield_percent
}
#ENTER THE REST HERE (only did first)
 
# Mining Stats
if (length(all_assets$data[[i]]$metrics$mining_stats$mining_algo) > 0){
  crypto_data[i,"mining_algorithm"] <- all_assets$data[[i]]$metrics$mining_stats$mining_algo
}
# #ENTER THE REST HERE (only did first)

# Developer Activity
if (length(all_assets$data[[i]]$metrics$developer_activity$stars) > 0){
  crypto_data[i,"github_stars"] <- all_assets$data[[i]]$metrics$developer_activity$stars
}
#ENTER THE REST HERE (only did first)
 
# ROI
if (length(all_assets$data[[i]]$metrics$roi_data$percent_change_last_1_week) > 0){
  crypto_data[i,"percent_change_last_1_week"] <- all_assets$data[[i]]$metrics$roi_data$percent_change_last_1_week
}
#ENTER THE REST HERE (only did first)
 
# ROI by Year
if (length(all_assets$data[[i]]$metrics$roi_by_year$`2019_usd_percent`) > 0){
  crypto_data[i,"2019_usd_percent"] <- all_assets$data[[i]]$metrics$roi_by_year$`2019_usd_percent` #added backticks because variable can't start with number
}
#ENTER THE REST HERE (only did first)

# Risk Metrics - Sharpe Ratios
if (length(all_assets$data[[i]]$metrics$risk_metrics$sharpe_ratios$last_30_days) > 0){
  crypto_data[i,"sharpe_last_30_days"] <- all_assets$data[[i]]$metrics$risk_metrics$sharpe_ratios$last_30_days
}
#ENTER THE REST HERE (only did first)

# Risk Metrics - Volatility
if (length(all_assets$data[[i]]$metrics$risk_metrics$volatility_stats$volatility_last_30_days) > 0){
  crypto_data[i,"volatility_last_30_days"] <- all_assets$data[[i]]$metrics$risk_metrics$volatility_stats$volatility_last_30_days
}
#ENTER THE REST HERE (only did first)

# Misc Data
if (length(all_assets$data[[i]]$metrics$misc_data$private_market_price_usd) > 0){
  crypto_data[i,"private_market_price_usd"] <- all_assets$data[[i]]$metrics$misc_data$private_market_price_usd
}
#ENTER THE REST HERE (only did first)
 
# Lend Rates
if (length(all_assets$data[[i]]$metrics$lend_rates$bitfinex) > 0){
  crypto_data[i,"lend_rates_bitfinex"] <- all_assets$data[[i]]$metrics$lend_rates$bitfinex
}
#ENTER THE REST HERE (only did first)

# Borrow Rates
if (length(all_assets$data[[i]]$metrics$borrow_rates$coin_list) > 0){
  crypto_data[i,"borrow_rates_coin_list"] <- all_assets$data[[i]]$metrics$borrow_rates$coin_list
}
#ENTER THE REST HERE (only did first)
 
# Loan Data
if (length(all_assets$data[[i]]$metrics$loan_data$originated_last_24_hours_usd) > 0){
  crypto_data[i,"loans_originated_last_24_hours_usd"] <- all_assets$data[[i]]$metrics$loan_data$originated_last_24_hours_usd
}
#ENTER THE REST HERE (only did first)
 
# Reddit
if (length(all_assets$data[[i]]$metrics$reddit$active_user_count) > 0){
  crypto_data[i,"reddit_active_user_count"] <- all_assets$data[[i]]$metrics$reddit$active_user_count
}
#ENTER THE REST HERE (only did first)
 
# Profile
if (length(all_assets$data[[i]]$profile$overview) > 0){
  crypto_data[i,"cycle_low_price"] <- all_assets$data[[i]]$profile$overview
}
#ENTER THE REST HERE (only did first)

}

# unique the data
crypto_data <- unique(crypto_data)

# add date and date_time
crypto_data$date <- Sys.Date()
crypto_data$date_time <- Sys.time()

# add pkDummy
crypto_data$pkDummy <- substr(crypto_data$date_time, 1,13)
# add pkey
crypto_data$pkey <- paste0(crypto_data$pkDummy,crypto_data$symbol)



#### HERE WRITE DATA TO DB ####
library(DBI)
library(RMariaDB)

Sys.setenv(user=db_user, pswd=db_pswd,ipAddress=db_ip)
getSqlConnection <- function(){
  con <-
    dbConnect(
      RMariaDB::MariaDB(),
      username = Sys.getenv('user'),
      password = Sys.getenv('pswd'),
      host = Sys.getenv('ipAddress'),
      dbname = 'ScrapeStorm'
    )
  return(con)
}
database_connection <- getSqlConnection()


# write data to database
#dbWriteTable(database_connection, "NEW TABLE HERE",df, append=T)


# Disconnect from the database
dbDisconnect(database_connection)


#### HERE PIN DATA ####































# Do I not even need Purrr? Could get list of symbols from db data pull 
#of latest symbols from ScrapeStorm table
