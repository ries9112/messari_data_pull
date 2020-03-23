library(httr)
library(jsonlite)
library(dplyr)
library(DBI)
library(RMariaDB)

get_response_content <- function(api_response) {
  httr::content(api_response,
                type = "text",
                encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE)
}


# all_assets <- httr::GET("https://data.messari.io/api/v1/assets")
# 
# all_assets <- get_response_content(all_assets)


# # Initialize new dataframe:
# crypto_data <- data.frame(1:20)
# 
# #### FOR Loop: #### 
# for (i in 1:20){
#   # Logic below can then be adapted to create iteration with purrr or for loop
#   crypto_data[i,'symbol'] <- all_assets$data$symbol
#   crypto_data[i,'name'] <- all_assets$data$name
#   # Market Data
#   crypto_data[i,'price_usd'] <- all_assets$data$metrics$market_data$price_usd
#   crypto_data[i,'price_btc'] <- all_assets$data$metrics$market_data$price_btc
#   # STEPS FAIL IF DON'T CHECK THEIR LENGTH FIRST:
#   if (length(all_assets$data$metrics$market_data$volume_last_24_hours) > 0){
#     crypto_data[i,'volume_last_24_hours'] <- all_assets$data$metrics$market_data$volume_last_24_hours
#   }
#   if (length(all_assets$data$metrics$market_data$real_volume_last_24_hours) > 0){
#     crypto_data[i,'real_volume_last_24_hours'] <- all_assets$data$metrics$market_data$real_volume_last_24_hours
#   }
#   # OHLCV 1 Hour
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_1_hour$open) > 0){
#     crypto_data[i,"ohlcv_1_hour_open"] <- all_assets$data$metrics$market_data$ohlcv_last_1_hour$open
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_1_hour$close) > 0){
#     crypto_data[i,"ohlcv_1_hour_close"] <- all_assets$data$metrics$market_data$ohlcv_last_1_hour$close
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_1_hour$high) > 0){
#     crypto_data[i,"ohlcv_1_hour_high"] <- all_assets$data$metrics$market_data$ohlcv_last_1_hour$high
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_1_hour$low) > 0){
#     crypto_data[i,"ohlcv_1_hour_low"] <- all_assets$data$metrics$market_data$ohlcv_last_1_hour$low
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_1_hour$volume) > 0){
#     crypto_data[i,"ohlcv_1_hour_volume"] <- all_assets$data$metrics$market_data$ohlcv_last_1_hour$volume
#   }
#   # OHLCV 24 Hour
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_24_hour$open) > 0){
#     crypto_data[i,"ohlcv_24_hour_open"] <- all_assets$data$metrics$market_data$ohlcv_last_24_hour$open
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_24_hour$close) > 0){
#     crypto_data[i,"ohlcv_24_hour_close"] <- all_assets$data$metrics$market_data$ohlcv_last_24_hour$close
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_24_hour$high) > 0){
#     crypto_data[i,"ohlcv_24_hour_high"] <- all_assets$data$metrics$market_data$ohlcv_last_24_hour$high
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_24_hour$low) > 0){
#     crypto_data[i,"ohlcv_24_hour_low"] <- all_assets$data$metrics$market_data$ohlcv_last_24_hour$low
#   }
#   if (length(all_assets$data$metrics$market_data$ohlcv_last_24_hour$volume) > 0){
#     crypto_data[i,"ohlcv_24_hour_volume"] <- all_assets$data$metrics$market_data$ohlcv_last_24_hour$volume
#   }
#   # Market Cap
#   if (length(all_assets$data$metrics$marketcap$current_marketcap_usd) > 0){
#     crypto_data[i,"market_cap_usd"] <- all_assets$data$metrics$marketcap$current_marketcap_usd
#   }
#   if (length(all_assets$data$metrics$marketcap$y_2050_marketcap_usd) > 0){
#     crypto_data[i,"y_2050_market_cap_usd"] <- all_assets$data$metrics$marketcap$y_2050_marketcap_usd
#   }
#   if (length(all_assets$data$metrics$marketcap$y_plusi0_marketcap_usd) > 0){
#     crypto_data[i,"y_plusi0_market_cap_usd"] <- all_assets$data$metrics$marketcap$y_plusi0_marketcap_usd
#   }
#   if (length(all_assets$data$metrics$marketcap$liquid_marketcap_usd) > 0){
#     crypto_data[i,"liquid_market_cap_usd"] <- all_assets$data$metrics$marketcap$liquid_marketcap_usd
#   }
#   if (length(all_assets$data$metrics$marketcap$volume_turnover_last_24_hours_percent) > 0){
#     crypto_data[i,"volume_turnover_24_hours_percent"] <- all_assets$data$metrics$marketcap$volume_turnover_last_24_hours_percent
#   }
#   # Supply
#   if (length(all_assets$data$metrics$supply$y_2050) > 0){
#     crypto_data[i,"supply_y_2050"] <- all_assets$data$metrics$supply$y_2050
#   }
#   if (length(all_assets$data$metrics$supply$annual_inflation_percent) > 0){
#     crypto_data[i,"annual_inflation_percent"] <- all_assets$data$metrics$supply$annual_inflation_percent
#   }
#   if (length(all_assets$data$metrics$supply$stock_to_flow) > 0){
#     crypto_data[i,"stock_to_flow"] <- all_assets$data$metrics$supply$stock_to_flow
#   }
#   if (length(all_assets$data$metrics$supply$y_plus10_issued_percent) > 0){
#     crypto_data[i,"y_plus10_issued_percent"] <- all_assets$data$metrics$supply$y_plus10_issued_percent
#   }
#   # Blockchain Stats
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$transaction_volume) > 0){
#     crypto_data[i,"transaction_volume"] <- all_assets$data$metrics$blockchain_stats_24_hours$transaction_volume
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$adjusted_transaction_volume) > 0){
#     crypto_data[i,"adjusted_transaction_volume"] <- all_assets$data$metrics$blockchain_stats_24_hours$adjusted_transaction_volume
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$sum_of_fees) > 0){
#     crypto_data[i,"sum_of_fees"] <- all_assets$data$metrics$blockchain_stats_24_hours$sum_of_fees
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$median_tx_value) > 0){
#     crypto_data[i,"median_tx_value"] <- all_assets$data$metrics$blockchain_stats_24_hours$median_tx_value
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$median_tx_fee) > 0){
#     crypto_data[i,"median_tx_fee"] <- all_assets$data$metrics$blockchain_stats_24_hours$median_tx_fee
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$count_of_active_addresses) > 0){
#     crypto_data[i,"count_of_active_addresses"] <- all_assets$data$metrics$blockchain_stats_24_hours$count_of_active_addresses
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$count_of_tx) > 0){
#     crypto_data[i,"count_of_tx"] <- all_assets$data$metrics$blockchain_stats_24_hours$count_of_tx
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$count_of_payments) > 0){
#     crypto_data[i,"count_of_payments"] <- all_assets$data$metrics$blockchain_stats_24_hours$count_of_payments
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$new_issuance) > 0){
#     crypto_data[i,"new_issuance"] <- all_assets$data$metrics$blockchain_stats_24_hours$new_issuance
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$average_difficulty) > 0){
#     crypto_data[i,"average_difficulty"] <- all_assets$data$metrics$blockchain_stats_24_hours$average_difficulty
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$kilobytes_added) > 0){
#     crypto_data[i,"kilobytes_added"] <- all_assets$data$metrics$blockchain_stats_24_hours$kilobytes_added
#   }
#   if (length(all_assets$data$metrics$blockchain_stats_24_hours$count_of_blocks_added) > 0){
#     crypto_data[i,"count_of_blocks_added"] <- all_assets$data$metrics$blockchain_stats_24_hours$count_of_blocks_added
#   }
#   # All Time High
#   if (length(all_assets$data$metrics$all_time_high$price) > 0){
#     crypto_data[i,"ath_price"] <- all_assets$data$metrics$all_time_high$price
#   }
#   if (length(all_assets$data$metrics$all_time_high$at) > 0){
#     crypto_data[i,"ath_date"] <- all_assets$data$metrics$all_time_high$at
#   }
#   if (length(all_assets$data$metrics$all_time_high$days_since) > 0){
#     crypto_data[i,"ath_days_since"] <- all_assets$data$metrics$all_time_high$days_since
#   }
#   if (length(all_assets$data$metrics$all_time_high$percent_down) > 0){
#     crypto_data[i,"ath_percent_down"] <- all_assets$data$metrics$all_time_high$percent_down
#   }
#   if (length(all_assets$data$metrics$all_time_high$breakeven_multiple) > 0){
#     crypto_data[i,"ath_breakeven_multiple"] <- all_assets$data$metrics$all_time_high$breakeven_multiple
#   }
#   # Cycle Low
#   if (length(all_assets$data$metrics$cycle_low$price) > 0){
#     crypto_data[i,"cycle_low_price"] <- all_assets$data$metrics$cycle_low$price
#   }
#   if (length(all_assets$data$metrics$cycle_low$at) > 0){
#     crypto_data[i,"cycle_low_date"] <- all_assets$data$metrics$cycle_low$at
#   }
#   if (length(all_assets$data$metrics$cycle_low$percent_up) > 0){
#     crypto_data[i,"cycle_low_percent_up"] <- all_assets$data$metrics$cycle_low$percent_up
#   }
#   if (length(all_assets$data$metrics$cycle_low$days_since) > 0){
#     crypto_data[i,"cycle_low_days_since"] <- all_assets$data$metrics$cycle_low$days_since
#   }
#   # Token Sale Stats
#   if (length(all_assets$data$metrics$token_sale_stats$sale_proceeds_usd) > 0){
#     crypto_data[i,"token_sale_proceeds_usd"] <- all_assets$data$metrics$token_sale_stats$sale_proceeds_usd
#   }
#   if (length(all_assets$data$metrics$token_sale_stats$sale_start_date) > 0){
#     crypto_data[i,"token_sale_start_date"] <- all_assets$data$metrics$token_sale_stats$sale_start_date
#   }
#   if (length(all_assets$data$metrics$token_sale_stats$sale_end_date) > 0){
#     crypto_data[i,"token_sale_end_date"] <- all_assets$data$metrics$token_sale_stats$sale_end_date
#   }
#   if (length(all_assets$data$metrics$token_sale_stats$roi_since_sale_usd_percent) > 0){
#     crypto_data[i,"roi_since_sale_usd_percent"] <- all_assets$data$metrics$token_sale_stats$roi_since_sale_usd_percent
#   }
#   if (length(all_assets$data$metrics$token_sale_stats$roi_since_sale_btc_percent) > 0){
#     crypto_data[i,"roi_since_sale_btc_percent"] <- all_assets$data$metrics$token_sale_stats$roi_since_sale_btc_percent
#   }
#   if (length(all_assets$data$metrics$token_sale_stats$roi_since_sale_eth_percent) > 0){
#     crypto_data[i,"roi_since_sale_eth_percent"] <- all_assets$data$metrics$token_sale_stats$roi_since_sale_eth_percent
#   }
#   # Staking Stats
#   if (length(all_assets$data$metrics$staking_stats$staking_yield_percent) > 0){
#     crypto_data[i,"staking_yield_percent"] <- all_assets$data$metrics$staking_stats$staking_yield_percent
#   }
#   if (length(all_assets$data$metrics$staking_stats$staking_type) > 0){
#     crypto_data[i,"staking_type"] <- all_assets$data$metrics$staking_stats$staking_type
#   }
#   if (length(all_assets$data$metrics$staking_stats$staking_minimum) > 0){
#     crypto_data[i,"staking_minimum"] <- all_assets$data$metrics$staking_stats$staking_minimum
#   }
#   if (length(all_assets$data$metrics$staking_stats$tokens_staked) > 0){
#     crypto_data[i,"tokens_staked"] <- all_assets$data$metrics$staking_stats$tokens_staked
#   }
#   if (length(all_assets$data$metrics$staking_stats$tokens_staked_percent) > 0){
#     crypto_data[i,"tokens_staked_percent"] <- all_assets$data$metrics$staking_stats$tokens_staked_percent
#   }
#   if (length(all_assets$data$metrics$staking_stats$real_staking_yield_percent) > 0){
#     crypto_data[i,"real_staking_yield_percent"] <- all_assets$data$metrics$staking_stats$real_staking_yield_percent
#   }
#   # Mining Stats
#   if (length(all_assets$data$metrics$mining_stats$mining_algo) > 0){
#     crypto_data[i,"mining_algorithm"] <- all_assets$data$metrics$mining_stats$mining_algo
#   }
#   if (length(all_assets$data$metrics$mining_stats$network_hash_rate) > 0){
#     crypto_data[i,"network_hash_rate"] <- all_assets$data$metrics$mining_stats$network_hash_rate
#   }
#   if (length(all_assets$data$metrics$mining_stats$available_on_nicehash_percent) > 0){
#     crypto_data[i,"available_on_nicehash_percent"] <- all_assets$data$metrics$mining_stats$available_on_nicehash_percent
#   }
#   if (length(all_assets$data$metrics$mining_stats$`1_hour_attack_cost`) > 0){
#     crypto_data[i,"1_hour_attack_cost"] <- all_assets$data$metrics$mining_stats$`1_hour_attack_cost`
#   }
#   if (length(all_assets$data$metrics$mining_stats$`24_hour_attack_cost`) > 0){
#     crypto_data[i,"24_hour_attack_cost"] <- all_assets$data$metrics$mining_stats$`24_hour_attack_cost`
#   }
#   if (length(all_assets$data$metrics$mining_stats$attack_appeal) > 0){
#     crypto_data[i,"attack_appeal"] <- all_assets$data$metrics$mining_stats$attack_appeal
#   }
#   # Developer Activity
#   if (length(all_assets$data$metrics$developer_activity$stars) > 0){
#     crypto_data[i,"github_stars"] <- all_assets$data$metrics$developer_activity$stars
#   }
#   if (length(all_assets$data$metrics$developer_activity$watchers) > 0){
#     crypto_data[i,"github_watchers"] <- all_assets$data$metrics$developer_activity$watchers
#   }
#   if (length(all_assets$data$metrics$developer_activity$commits_last_3_months) > 0){
#     crypto_data[i,"github_commits_last_3_months"] <- all_assets$data$metrics$developer_activity$commits_last_3_months
#   }
#   if (length(all_assets$data$metrics$developer_activity$commits_last_1_year) > 0){
#     crypto_data[i,"github_commits_last_1_year"] <- all_assets$data$metrics$developer_activity$commits_last_1_year
#   }
#   if (length(all_assets$data$metrics$developer_activity$lines_added_last_3_months) > 0){
#     crypto_data[i,"github_lines_added_last_3_months"] <- all_assets$data$metrics$developer_activity$lines_added_last_3_months
#   }
#   if (length(all_assets$data$metrics$developer_activity$lines_added_last_1_year) > 0){
#     crypto_data[i,"github_lines_added_last_1_year"] <- all_assets$data$metrics$developer_activity$lines_added_last_1_year
#   }
#   if (length(all_assets$data$metrics$developer_activity$lines_deleted_last_3_months) > 0){
#     crypto_data[i,"github_lines_deleted_last_3_months"] <- all_assets$data$metrics$developer_activity$lines_deleted_last_3_months
#   }
#   if (length(all_assets$data$metrics$developer_activity$lines_deleted_last_1_year) > 0){
#     crypto_data[i,"github_lines_deleted_last_1_year"] <- all_assets$data$metrics$developer_activity$lines_deleted_last_1_year
#   }
#   # ROI
#   if (length(all_assets$data$metrics$roi_data$percent_change_last_1_week) > 0){
#     crypto_data[i,"percent_change_last_1_week"] <- all_assets$data$metrics$roi_data$percent_change_last_1_week
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_last_1_month) > 0){
#     crypto_data[i,"percent_change_last_1_month"] <- all_assets$data$metrics$roi_data$percent_change_last_1_month
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_last_3_months) > 0){
#     crypto_data[i,"percent_change_last_3_months"] <- all_assets$data$metrics$roi_data$percent_change_last_3_months
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_last_1_year) > 0){
#     crypto_data[i,"percent_change_last_1_year"] <- all_assets$data$metrics$roi_data$percent_change_last_1_year
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_btc_last_1_week) > 0){
#     crypto_data[i,"percent_change_btc_last_1_week"] <- all_assets$data$metrics$roi_data$percent_change_btc_last_1_week
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_btc_last_1_month) > 0){
#     crypto_data[i,"percent_change_btc_last_1_month"] <- all_assets$data$metrics$roi_data$percent_change_btc_last_1_month
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_btc_last_3_months) > 0){
#     crypto_data[i,"percent_change_btc_last_3_months"] <- all_assets$data$metrics$roi_data$percent_change_btc_last_3_months
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_btc_last_1_year) > 0){
#     crypto_data[i,"percent_change_btc_last_1_year"] <- all_assets$data$metrics$roi_data$percent_change_btc_last_1_year
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_btc_last_1_year) > 0){
#     crypto_data[i,"percent_change_btc_last_1_year"] <- all_assets$data$metrics$roi_data$percent_change_btc_last_1_year
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_month_to_date) > 0){
#     crypto_data[i,"percent_change_month_to_date"] <- all_assets$data$metrics$roi_data$percent_change_month_to_date
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_quarter_to_date) > 0){
#     crypto_data[i,"percent_change_quarter_to_date"] <- all_assets$data$metrics$roi_data$percent_change_quarter_to_date
#   }
#   if (length(all_assets$data$metrics$roi_data$percent_change_year_to_date) > 0){
#     crypto_data[i,"percent_change_year_to_date"] <- all_assets$data$metrics$roi_data$percent_change_year_to_date
#   }
#   # ROI by Year
#   if (length(all_assets$data$metrics$roi_by_year$`2019_usd_percent`) > 0){
#     crypto_data[i,"2019_usd_percent_change"] <- all_assets$data$metrics$roi_by_year$`2019_usd_percent` 
#   }
#   if (length(all_assets$data$metrics$roi_by_year$`2018_usd_percent`) > 0){
#     crypto_data[i,"2018_usd_percent_change"] <- all_assets$data$metrics$roi_by_year$`2018_usd_percent` 
#   }
#   if (length(all_assets$data$metrics$roi_by_year$`2017_usd_percent`) > 0){
#     crypto_data[i,"2017_usd_percent_change"] <- all_assets$data$metrics$roi_by_year$`2017_usd_percent` 
#   }
#   if (length(all_assets$data$metrics$roi_by_year$`2016_usd_percent`) > 0){
#     crypto_data[i,"2016_usd_percent_change"] <- all_assets$data$metrics$roi_by_year$`2016_usd_percent` 
#   }
#   if (length(all_assets$data$metrics$roi_by_year$`2015_usd_percent`) > 0){
#     crypto_data[i,"2015_usd_percent_change"] <- all_assets$data$metrics$roi_by_year$`2015_usd_percent` 
#   }
#   # Did not include the rest since they aren't relevant for most cryptocurrencies
#   
#   # Risk Metrics - Sharpe Ratios
#   if (length(all_assets$data$metrics$risk_metrics$sharpe_ratios$last_30_days) > 0){
#     crypto_data[i,"sharpe_last_30_days"] <- all_assets$data$metrics$risk_metrics$sharpe_ratios$last_30_days
#   }
#   if (length(all_assets$data$metrics$risk_metrics$sharpe_ratios$last_90_days) > 0){
#     crypto_data[i,"sharpe_last_90_days"] <- all_assets$data$metrics$risk_metrics$sharpe_ratios$last_90_days
#   }
#   if (length(all_assets$data$metrics$risk_metrics$sharpe_ratios$last_1_year) > 0){
#     crypto_data[i,"sharpe_last_1_year"] <- all_assets$data$metrics$risk_metrics$sharpe_ratios$last_1_year
#   }
#   if (length(all_assets$data$metrics$risk_metrics$sharpe_ratios$last_3_years) > 0){
#     crypto_data[i,"sharpe_last_3_years"] <- all_assets$data$metrics$risk_metrics$sharpe_ratios$last_3_years
#   }
#   # Risk Metrics - Volatility
#   if (length(all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_30_days) > 0){
#     crypto_data[i,"volatility_last_30_days"] <- all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_30_days
#   }
#   if (length(all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_90_days) > 0){
#     crypto_data[i,"volatility_last_90_days"] <- all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_90_days
#   }
#   if (length(all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_1_year) > 0){
#     crypto_data[i,"volatility_last_1_year"] <- all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_1_year
#   }
#   if (length(all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_3_years) > 0){
#     crypto_data[i,"volatility_last_3_years"] <- all_assets$data$metrics$risk_metrics$volatility_stats$volatility_last_3_years
#   }
#   # Misc Data
#   if (length(all_assets$data$metrics$misc_data$private_market_price_usd) > 0){
#     crypto_data[i,"private_market_price_usd"] <- all_assets$data$metrics$misc_data$private_market_price_usd
#   }
#   if (length(all_assets$data$metrics$misc_data$vladimir_club_cost) > 0){
#     crypto_data[i,"vladimir_club_cost"] <- all_assets$data$metrics$misc_data$vladimir_club_cost
#   }
#   if (length(all_assets$data$metrics$misc_data$btc_current_normalized_supply_price_usd) > 0){
#     crypto_data[i,"btc_current_normalized_supply_price_usd"] <- all_assets$data$metrics$misc_data$btc_current_normalized_supply_price_usd
#   }
#   if (length(all_assets$data$metrics$misc_data$btc_y2050_normalized_supply_price_usd) > 0){
#     crypto_data[i,"btc_y2050_normalized_supply_price_usd"] <- all_assets$data$metrics$misc_data$btc_y2050_normalized_supply_price_usd
#   }
#   if (length(all_assets$data$metrics$misc_data$asset_created_at) > 0){
#     crypto_data[i,"asset_created_date"] <- all_assets$data$metrics$misc_data$asset_created_at
#   }
#   if (length(all_assets$data$metrics$misc_data$asset_age_days) > 0){
#     crypto_data[i,"asset_age_days"] <- all_assets$data$metrics$misc_data$asset_age_days
#   }
#   if (length(all_assets$data$metrics$misc_data$categories) > 0){
#     crypto_data[i,"category"] <- all_assets$data$metrics$misc_data$categories
#   }
#   # if (length(all_assets$data$metrics$misc_data$sectors) > 0){
#   #   crypto_data[i,"sector"] <- all_assets$data$metrics$misc_data$sectors
#   # }
#   # Lend Rates
#   if (length(all_assets$data$metrics$lend_rates$bitfinex) > 0){
#     crypto_data[i,"lend_rates_bitfinex"] <- all_assets$data$metrics$lend_rates$bitfinex
#   }
#   if (length(all_assets$data$metrics$lend_rates$block_fi) > 0){
#     crypto_data[i,"lend_rates_block_fi"] <- all_assets$data$metrics$lend_rates$block_fi
#   }
#   if (length(all_assets$data$metrics$lend_rates$celsius) > 0){
#     crypto_data[i,"lend_rates_celsius"] <- all_assets$data$metrics$lend_rates$celsius
#   }
#   # if (length(all_assets$data$metrics$lend_rates$coin_list) > 0){
#   #   crypto_data[i,"lend_rates_coin_list"] <- all_assets$data$metrics$lend_rates$celsius
#   # }
#   if (length(all_assets$data$metrics$lend_rates$poloniex) > 0){
#     crypto_data[i,"lend_rates_poloniex"] <- all_assets$data$metrics$lend_rates$poloniex
#   }
#   # Borrow Rates
#   if (length(all_assets$data$metrics$borrow_rates$coin_list) > 0){
#     crypto_data[i,"borrow_rates_coin_list"] <- all_assets$data$metrics$borrow_rates$coin_list
#   }
#   # Loan Data
#   if (length(all_assets$data$metrics$loan_data$originated_last_24_hours_usd) > 0){
#     crypto_data[i,"loans_originated_last_24_hours_usd"] <- all_assets$data$metrics$loan_data$originated_last_24_hours_usd
#   }
#   if (length(all_assets$data$metrics$loan_data$outstanding_debt_usd) > 0){
#     crypto_data[i,"loans_outstanding_debt_usd"] <- all_assets$data$metrics$loan_data$originated_last_24_hours_usd
#   }
#   if (length(all_assets$data$metrics$loan_data$repaid_last_24_hours_usd) > 0){
#     crypto_data[i,"loans_repaid_last_24_hours_usd"] <- all_assets$data$metrics$loan_data$repaid_last_24_hours_usd
#   }
#   if (length(all_assets$data$metrics$loan_data$collateralized_last_24_hours_usd) > 0){
#     crypto_data[i,"loans_collateralized_last_24_hours_usd"] <- all_assets$data$metrics$loan_data$collateralized_last_24_hours_usd
#   }
#   if (length(all_assets$data$metrics$loan_data$collateral_liquidated_last_24_hours_usd) > 0){
#     crypto_data[i,"loans_collateral_liquidated_last_24_hours_usd"] <- all_assets$data$metrics$loan_data$collateral_liquidated_last_24_hours_usd
#   }
#   # Reddit
#   if (length(all_assets$data$metrics$reddit$active_user_count) > 0){
#     crypto_data[i,"reddit_active_user_count"] <- all_assets$data$metrics$reddit$active_user_count
#   }
#   if (length(all_assets$data$metrics$reddit$subscribers) > 0){
#     crypto_data[i,"reddit_subscribers"] <- all_assets$data$metrics$reddit$subscribers
#   }
#   # Profile
#   if (length(all_assets$data$profile$tagline) > 0){
#     crypto_data[i,"tagline"] <- all_assets$data$profile$tagline
#   }
#   if (length(all_assets$data$profile$overview) > 0){
#     crypto_data[i,"overview"] <- all_assets$data$profile$overview
#   }
#   if (length(all_assets$data$profile$background) > 0){
#     crypto_data[i,"background"] <- all_assets$data$profile$background
#   }
#   if (length(all_assets$data$profile$technology) > 0){
#     crypto_data[i,"technology"] <- all_assets$data$profile$technology
#   }
#   if (length(all_assets$data$profile$category) > 0){
#     crypto_data[i,"category"] <- all_assets$data$profile$category
#   }
#   if (length(all_assets$data$profile$sector) > 0){
#     crypto_data[i,"sector"] <- all_assets$data$profile$sector
#   }
#   if (length(all_assets$data$profile$tag) > 0){
#     crypto_data[i,"tag"] <- all_assets$data$profile$tag
#   }
#   if (length(all_assets$data$profile$sfarScore) > 0){
#     crypto_data[i,"sfarScore"] <- all_assets$data$profile$sfarScore
#   }
#   #Decided to stop here
# }
# 
# # unique the data
# crypto_data <- unique(crypto_data)
# 
# # add date and date_time
# crypto_data$date <- Sys.Date()
# crypto_data$date_time <- Sys.time()
# 
# # add pkDummy
# crypto_data$pkDummy <- substr(crypto_data$date_time, 1,13)
# # add pkey
# crypto_data$pkey <- paste0(crypto_data$pkDummy,crypto_data$symbol)
# 
# # rename first field
# crypto_data <- crypto_data %>% rename(Rank=X1.20)

#### HERE WRITE DATA TO DB ####
# getSqlConnection <- function(){
#   con <-
#     dbConnect(
#       RMariaDB::MariaDB(),
#       username = db_user,
#       password = db_pswd,
#       host = db_ip,
#       dbname = 'Octoparse'
#     )
#   return(con)
# }
# database_connection <- getSqlConnection()
# 
# # write data to database
# dbWriteTable(database_connection, "Messari_R", crypto_data, append=T)

# query symbols
getSqlConnection <- function(){
  con <-
    dbConnect(
      RMariaDB::MariaDB(),
      username = db_user,
      password = db_pswd,
      host = db_ip,
      dbname = 'ScrapeStorm'
    )
  return(con)
}
database_connection <- getSqlConnection()
query <- "SELECT * FROM SymbolsMessariJoin WHERE pkDummy = (select max(pkDummy) from ScrapeStorm.SymbolsMessariJoin)"
symbols <- dbFetch(dbSendQuery(database_connection, query), 20000)



#### KEEP GOING HERE

### After top 20, also setup logic to get unique symbols from db and get 
# data for the rest of the cryptocurrencies

# https://messari.io/api/docs#operation/Get%20Asset%20Metrics

# Use purrr to iterate through every symbol option
full_data <- data.frame()
full_dataset <- data.frame()
for (i in 1:nrow(symbols)){
  tryCatch({
  all_assets <- httr::GET(paste0("https://data.messari.io/api/v1/assets/",symbols[i,'Symbol'],"/metrics"))
  all_assets <- get_response_content(all_assets)
  
  if (length(all_assets$data$symbol) > 0){
    full_data[i, 'symbol'] <- all_assets$data$symbol
  }
  if (length(all_assets$data$name) > 0){
    full_data[i,'name'] <- all_assets$data$name
  }
  # Market Data
  if (length(all_assets$data$market_data$price_usd) > 0){
    full_data[i,'price_usd'] <- all_assets$data$market_data$price_usd
  }
  if (length(all_assets$data$market_data$price_btc) > 0){
    full_data[i,'price_btc'] <- all_assets$data$market_data$price_btc
  }
  # STEPS FAIL IF DON'T CHECK THEIR LENGTH FIRST:
  if (length(all_assets$data$market_data$volume_last_24_hours) > 0){
    full_data[i,'volume_last_24_hours'] <- all_assets$data$market_data$volume_last_24_hours
  }
  if (length(all_assets$data$market_data$real_volume_last_24_hours) > 0){
    full_data[i,'real_volume_last_24_hours'] <- all_assets$data$market_data$real_volume_last_24_hours
  }
  # OHLCV 1 Hour
  if (length(all_assets$data$market_data$ohlcv_last_1_hour$open) > 0){
    full_data[i,"ohlcv_1_hour_open"] <- all_assets$data$market_data$ohlcv_last_1_hour$open
  }
  if (length(all_assets$data$market_data$ohlcv_last_1_hour$close) > 0){
    full_data[i,"ohlcv_1_hour_close"] <- all_assets$data$market_data$ohlcv_last_1_hour$close
  }
  if (length(all_assets$data$market_data$ohlcv_last_1_hour$high) > 0){
    full_data[i,"ohlcv_1_hour_high"] <- all_assets$data$market_data$ohlcv_last_1_hour$high
  }
  if (length(all_assets$data$market_data$ohlcv_last_1_hour$low) > 0){
    full_data[i,"ohlcv_1_hour_low"] <- all_assets$data$market_data$ohlcv_last_1_hour$low
  }
  if (length(all_assets$data$market_data$ohlcv_last_1_hour$volume) > 0){
    full_data[i,"ohlcv_1_hour_volume"] <- all_assets$data$market_data$ohlcv_last_1_hour$volume
  }
  # OHLCV 24 Hour
  if (length(all_assets$data$market_data$ohlcv_last_24_hour$open) > 0){
    full_data[i,"ohlcv_24_hour_open"] <- all_assets$data$market_data$ohlcv_last_24_hour$open
  }
  if (length(all_assets$data$market_data$ohlcv_last_24_hour$close) > 0){
    full_data[i,"ohlcv_24_hour_close"] <- all_assets$data$market_data$ohlcv_last_24_hour$close
  }
  if (length(all_assets$data$market_data$ohlcv_last_24_hour$high) > 0){
    full_data[i,"ohlcv_24_hour_high"] <- all_assets$data$market_data$ohlcv_last_24_hour$high
  }
  if (length(all_assets$data$market_data$ohlcv_last_24_hour$low) > 0){
    full_data[i,"ohlcv_24_hour_low"] <- all_assets$data$market_data$ohlcv_last_24_hour$low
  }
  if (length(all_assets$data$market_data$ohlcv_last_24_hour$volume) > 0){
    full_data[i,"ohlcv_24_hour_volume"] <- all_assets$data$market_data$ohlcv_last_24_hour$volume
  }
  # Market Cap
  if (length(all_assets$data$marketcap$current_marketcap_usd) > 0){
    full_data[i,"market_cap_usd"] <- all_assets$data$marketcap$current_marketcap_usd
  }
  if (length(all_assets$data$marketcap$y_2050_marketcap_usd) > 0){
    full_data[i,"y_2050_market_cap_usd"] <- all_assets$data$marketcap$y_2050_marketcap_usd
  }
  if (length(all_assets$data$marketcap$y_plusi0_marketcap_usd) > 0){
    full_data[i,"y_plusi0_market_cap_usd"] <- all_assets$data$marketcap$y_plusi0_marketcap_usd
  }
  if (length(all_assets$data$marketcap$liquid_marketcap_usd) > 0){
    full_data[i,"liquid_market_cap_usd"] <- all_assets$data$marketcap$liquid_marketcap_usd
  }
  if (length(all_assets$data$marketcap$volume_turnover_last_24_hours_percent) > 0){
    full_data[i,"volume_turnover_24_hours_percent"] <- all_assets$data$marketcap$volume_turnover_last_24_hours_percent
  }
  # Supply
  if (length(all_assets$data$supply$y_2050) > 0){
    full_data[i,"supply_y_2050"] <- all_assets$data$supply$y_2050
  }
  if (length(all_assets$data$supply$annual_inflation_percent) > 0){
    full_data[i,"annual_inflation_percent"] <- all_assets$data$supply$annual_inflation_percent
  }
  if (length(all_assets$data$supply$stock_to_flow) > 0){
    full_data[i,"stock_to_flow"] <- all_assets$data$supply$stock_to_flow
  }
  if (length(all_assets$data$supply$y_plus10_issued_percent) > 0){
    full_data[i,"y_plus10_issued_percent"] <- all_assets$data$supply$y_plus10_issued_percent
  }
  # Blockchain Stats
  if (length(all_assets$data$blockchain_stats_24_hours$transaction_volume) > 0){
    full_data[i,"transaction_volume"] <- all_assets$data$blockchain_stats_24_hours$transaction_volume
  }
  if (length(all_assets$data$blockchain_stats_24_hours$adjusted_transaction_volume) > 0){
    full_data[i,"adjusted_transaction_volume"] <- all_assets$data$blockchain_stats_24_hours$adjusted_transaction_volume
  }
  if (length(all_assets$data$blockchain_stats_24_hours$sum_of_fees) > 0){
    full_data[i,"sum_of_fees"] <- all_assets$data$blockchain_stats_24_hours$sum_of_fees
  }
  if (length(all_assets$data$blockchain_stats_24_hours$median_tx_value) > 0){
    full_data[i,"median_tx_value"] <- all_assets$data$blockchain_stats_24_hours$median_tx_value
  }
  if (length(all_assets$data$blockchain_stats_24_hours$median_tx_fee) > 0){
    full_data[i,"median_tx_fee"] <- all_assets$data$blockchain_stats_24_hours$median_tx_fee
  }
  if (length(all_assets$data$blockchain_stats_24_hours$count_of_active_addresses) > 0){
    full_data[i,"count_of_active_addresses"] <- all_assets$data$blockchain_stats_24_hours$count_of_active_addresses
  }
  if (length(all_assets$data$blockchain_stats_24_hours$count_of_tx) > 0){
    full_data[i,"count_of_tx"] <- all_assets$data$blockchain_stats_24_hours$count_of_tx
  }
  if (length(all_assets$data$blockchain_stats_24_hours$count_of_payments) > 0){
    full_data[i,"count_of_payments"] <- all_assets$data$blockchain_stats_24_hours$count_of_payments
  }
  if (length(all_assets$data$blockchain_stats_24_hours$new_issuance) > 0){
    full_data[i,"new_issuance"] <- all_assets$data$blockchain_stats_24_hours$new_issuance
  }
  if (length(all_assets$data$blockchain_stats_24_hours$average_difficulty) > 0){
    full_data[i,"average_difficulty"] <- all_assets$data$blockchain_stats_24_hours$average_difficulty
  }
  if (length(all_assets$data$blockchain_stats_24_hours$kilobytes_added) > 0){
    full_data[i,"kilobytes_added"] <- all_assets$data$blockchain_stats_24_hours$kilobytes_added
  }
  if (length(all_assets$data$blockchain_stats_24_hours$count_of_blocks_added) > 0){
    full_data[i,"count_of_blocks_added"] <- all_assets$data$blockchain_stats_24_hours$count_of_blocks_added
  }
  # All Time High
  if (length(all_assets$data$all_time_high$price) > 0){
    full_data[i,"ath_price"] <- all_assets$data$all_time_high$price
  }
  if (length(all_assets$data$all_time_high$at) > 0){
    full_data[i,"ath_date"] <- all_assets$data$all_time_high$at
  }
  if (length(all_assets$data$all_time_high$days_since) > 0){
    full_data[i,"ath_days_since"] <- all_assets$data$all_time_high$days_since
  }
  if (length(all_assets$data$all_time_high$percent_down) > 0){
    full_data[i,"ath_percent_down"] <- all_assets$data$all_time_high$percent_down
  }
  if (length(all_assets$data$all_time_high$breakeven_multiple) > 0){
    full_data[i,"ath_breakeven_multiple"] <- all_assets$data$all_time_high$breakeven_multiple
  }
  # Cycle Low
  if (length(all_assets$data$cycle_low$price) > 0){
    full_data[i,"cycle_low_price"] <- all_assets$data$cycle_low$price
  }
  if (length(all_assets$data$cycle_low$at) > 0){
    full_data[i,"cycle_low_date"] <- all_assets$data$cycle_low$at
  }
  if (length(all_assets$data$cycle_low$percent_up) > 0){
    full_data[i,"cycle_low_percent_up"] <- all_assets$data$cycle_low$percent_up
  }
  if (length(all_assets$data$cycle_low$days_since) > 0){
    full_data[i,"cycle_low_days_since"] <- all_assets$data$cycle_low$days_since
  }
  # Token Sale Stats
  if (length(all_assets$data$token_sale_stats$sale_proceeds_usd) > 0){
    full_data[i,"token_sale_proceeds_usd"] <- all_assets$data$token_sale_stats$sale_proceeds_usd
  }
  if (length(all_assets$data$token_sale_stats$sale_start_date) > 0){
    full_data[i,"token_sale_start_date"] <- all_assets$data$token_sale_stats$sale_start_date
  }
  if (length(all_assets$data$token_sale_stats$sale_end_date) > 0){
    full_data[i,"token_sale_end_date"] <- all_assets$data$token_sale_stats$sale_end_date
  }
  if (length(all_assets$data$token_sale_stats$roi_since_sale_usd_percent) > 0){
    full_data[i,"roi_since_sale_usd_percent"] <- all_assets$data$token_sale_stats$roi_since_sale_usd_percent
  }
  if (length(all_assets$data$token_sale_stats$roi_since_sale_btc_percent) > 0){
    full_data[i,"roi_since_sale_btc_percent"] <- all_assets$data$token_sale_stats$roi_since_sale_btc_percent
  }
  if (length(all_assets$data$token_sale_stats$roi_since_sale_eth_percent) > 0){
    full_data[i,"roi_since_sale_eth_percent"] <- all_assets$data$token_sale_stats$roi_since_sale_eth_percent
  }
  # Staking Stats
  if (length(all_assets$data$staking_stats$staking_yield_percent) > 0){
    full_data[i,"staking_yield_percent"] <- all_assets$data$staking_stats$staking_yield_percent
  }
  if (length(all_assets$data$staking_stats$staking_type) > 0){
    full_data[i,"staking_type"] <- all_assets$data$staking_stats$staking_type
  }
  if (length(all_assets$data$staking_stats$staking_minimum) > 0){
    full_data[i,"staking_minimum"] <- all_assets$data$staking_stats$staking_minimum
  }
  if (length(all_assets$data$staking_stats$tokens_staked) > 0){
    full_data[i,"tokens_staked"] <- all_assets$data$staking_stats$tokens_staked
  }
  if (length(all_assets$data$staking_stats$tokens_staked_percent) > 0){
    full_data[i,"tokens_staked_percent"] <- all_assets$data$staking_stats$tokens_staked_percent
  }
  if (length(all_assets$data$staking_stats$real_staking_yield_percent) > 0){
    full_data[i,"real_staking_yield_percent"] <- all_assets$data$staking_stats$real_staking_yield_percent
  }
  # Mining Stats
  if (length(all_assets$data$mining_stats$mining_algo) > 0){
    full_data[i,"mining_algorithm"] <- all_assets$data$mining_stats$mining_algo
  }
  if (length(all_assets$data$mining_stats$network_hash_rate) > 0){
    full_data[i,"network_hash_rate"] <- all_assets$data$mining_stats$network_hash_rate
  }
  if (length(all_assets$data$mining_stats$available_on_nicehash_percent) > 0){
    full_data[i,"available_on_nicehash_percent"] <- all_assets$data$mining_stats$available_on_nicehash_percent
  }
  if (length(all_assets$data$mining_stats$`1_hour_attack_cost`) > 0){
    full_data[i,"1_hour_attack_cost"] <- all_assets$data$mining_stats$`1_hour_attack_cost`
  }
  if (length(all_assets$data$mining_stats$`24_hour_attack_cost`) > 0){
    full_data[i,"24_hour_attack_cost"] <- all_assets$data$mining_stats$`24_hour_attack_cost`
  }
  if (length(all_assets$data$mining_stats$attack_appeal) > 0){
    full_data[i,"attack_appeal"] <- all_assets$data$mining_stats$attack_appeal
  }
  # Developer Activity
  if (length(all_assets$data$developer_activity$stars) > 0){
    full_data[i,"github_stars"] <- all_assets$data$developer_activity$stars
  }
  if (length(all_assets$data$developer_activity$watchers) > 0){
    full_data[i,"github_watchers"] <- all_assets$data$developer_activity$watchers
  }
  if (length(all_assets$data$developer_activity$commits_last_3_months) > 0){
    full_data[i,"github_commits_last_3_months"] <- all_assets$data$developer_activity$commits_last_3_months
  }
  if (length(all_assets$data$developer_activity$commits_last_1_year) > 0){
    full_data[i,"github_commits_last_1_year"] <- all_assets$data$developer_activity$commits_last_1_year
  }
  if (length(all_assets$data$developer_activity$lines_added_last_3_months) > 0){
    full_data[i,"github_lines_added_last_3_months"] <- all_assets$data$developer_activity$lines_added_last_3_months
  }
  if (length(all_assets$data$developer_activity$lines_added_last_1_year) > 0){
    full_data[i,"github_lines_added_last_1_year"] <- all_assets$data$developer_activity$lines_added_last_1_year
  }
  if (length(all_assets$data$developer_activity$lines_deleted_last_3_months) > 0){
    full_data[i,"github_lines_deleted_last_3_months"] <- all_assets$data$developer_activity$lines_deleted_last_3_months
  }
  if (length(all_assets$data$developer_activity$lines_deleted_last_1_year) > 0){
    full_data[i,"github_lines_deleted_last_1_year"] <- all_assets$data$developer_activity$lines_deleted_last_1_year
  }
  # ROI
  if (length(all_assets$data$roi_data$percent_change_last_1_week) > 0){
    full_data[i,"percent_change_last_1_week"] <- all_assets$data$roi_data$percent_change_last_1_week
  }
  if (length(all_assets$data$roi_data$percent_change_last_1_month) > 0){
    full_data[i,"percent_change_last_1_month"] <- all_assets$data$roi_data$percent_change_last_1_month
  }
  if (length(all_assets$data$roi_data$percent_change_last_3_months) > 0){
    full_data[i,"percent_change_last_3_months"] <- all_assets$data$roi_data$percent_change_last_3_months
  }
  if (length(all_assets$data$roi_data$percent_change_last_1_year) > 0){
    full_data[i,"percent_change_last_1_year"] <- all_assets$data$roi_data$percent_change_last_1_year
  }
  if (length(all_assets$data$roi_data$percent_change_btc_last_1_week) > 0){
    full_data[i,"percent_change_btc_last_1_week"] <- all_assets$data$roi_data$percent_change_btc_last_1_week
  }
  if (length(all_assets$data$roi_data$percent_change_btc_last_1_month) > 0){
    full_data[i,"percent_change_btc_last_1_month"] <- all_assets$data$roi_data$percent_change_btc_last_1_month
  }
  if (length(all_assets$data$roi_data$percent_change_btc_last_3_months) > 0){
    full_data[i,"percent_change_btc_last_3_months"] <- all_assets$data$roi_data$percent_change_btc_last_3_months
  }
  if (length(all_assets$data$roi_data$percent_change_btc_last_1_year) > 0){
    full_data[i,"percent_change_btc_last_1_year"] <- all_assets$data$roi_data$percent_change_btc_last_1_year
  }
  if (length(all_assets$data$roi_data$percent_change_btc_last_1_year) > 0){
    full_data[i,"percent_change_btc_last_1_year"] <- all_assets$data$roi_data$percent_change_btc_last_1_year
  }
  if (length(all_assets$data$roi_data$percent_change_month_to_date) > 0){
    full_data[i,"percent_change_month_to_date"] <- all_assets$data$roi_data$percent_change_month_to_date
  }
  if (length(all_assets$data$roi_data$percent_change_quarter_to_date) > 0){
    full_data[i,"percent_change_quarter_to_date"] <- all_assets$data$roi_data$percent_change_quarter_to_date
  }
  if (length(all_assets$data$roi_data$percent_change_year_to_date) > 0){
    full_data[i,"percent_change_year_to_date"] <- all_assets$data$roi_data$percent_change_year_to_date
  }
  # ROI by Year
  if (length(all_assets$data$roi_by_year$`2019_usd_percent`) > 0){
    full_data[i,"2019_usd_percent_change"] <- all_assets$data$roi_by_year$`2019_usd_percent` 
  }
  if (length(all_assets$data$roi_by_year$`2018_usd_percent`) > 0){
    full_data[i,"2018_usd_percent_change"] <- all_assets$data$roi_by_year$`2018_usd_percent` 
  }
  if (length(all_assets$data$roi_by_year$`2017_usd_percent`) > 0){
    full_data[i,"2017_usd_percent_change"] <- all_assets$data$roi_by_year$`2017_usd_percent` 
  }
  if (length(all_assets$data$roi_by_year$`2016_usd_percent`) > 0){
    full_data[i,"2016_usd_percent_change"] <- all_assets$data$roi_by_year$`2016_usd_percent` 
  }
  if (length(all_assets$data$roi_by_year$`2015_usd_percent`) > 0){
    full_data[i,"2015_usd_percent_change"] <- all_assets$data$roi_by_year$`2015_usd_percent` 
  }
  # Did not include the rest since they aren't relevant for most cryptocurrencies
  
  # Risk Metrics - Sharpe Ratios
  if (length(all_assets$data$risk_metrics$sharpe_ratios$last_30_days) > 0){
    full_data[i,"sharpe_last_30_days"] <- all_assets$data$risk_metrics$sharpe_ratios$last_30_days
  }
  if (length(all_assets$data$risk_metrics$sharpe_ratios$last_90_days) > 0){
    full_data[i,"sharpe_last_90_days"] <- all_assets$data$risk_metrics$sharpe_ratios$last_90_days
  }
  if (length(all_assets$data$risk_metrics$sharpe_ratios$last_1_year) > 0){
    full_data[i,"sharpe_last_1_year"] <- all_assets$data$risk_metrics$sharpe_ratios$last_1_year
  }
  if (length(all_assets$data$risk_metrics$sharpe_ratios$last_3_years) > 0){
    full_data[i,"sharpe_last_3_years"] <- all_assets$data$risk_metrics$sharpe_ratios$last_3_years
  }
  # Risk Metrics - Volatility
  if (length(all_assets$data$risk_metrics$volatility_stats$volatility_last_30_days) > 0){
    full_data[i,"volatility_last_30_days"] <- all_assets$data$risk_metrics$volatility_stats$volatility_last_30_days
  }
  if (length(all_assets$data$risk_metrics$volatility_stats$volatility_last_90_days) > 0){
    full_data[i,"volatility_last_90_days"] <- all_assets$data$risk_metrics$volatility_stats$volatility_last_90_days
  }
  if (length(all_assets$data$risk_metrics$volatility_stats$volatility_last_1_year) > 0){
    full_data[i,"volatility_last_1_year"] <- all_assets$data$risk_metrics$volatility_stats$volatility_last_1_year
  }
  if (length(all_assets$data$risk_metrics$volatility_stats$volatility_last_3_years) > 0){
    full_data[i,"volatility_last_3_years"] <- all_assets$data$risk_metrics$volatility_stats$volatility_last_3_years
  }
  # Misc Data
  if (length(all_assets$data$misc_data$private_market_price_usd) > 0){
    full_data[i,"private_market_price_usd"] <- all_assets$data$misc_data$private_market_price_usd
  }
  if (length(all_assets$data$misc_data$vladimir_club_cost) > 0){
    full_data[i,"vladimir_club_cost"] <- all_assets$data$misc_data$vladimir_club_cost
  }
  if (length(all_assets$data$misc_data$btc_current_normalized_supply_price_usd) > 0){
    full_data[i,"btc_current_normalized_supply_price_usd"] <- all_assets$data$misc_data$btc_current_normalized_supply_price_usd
  }
  if (length(all_assets$data$misc_data$btc_y2050_normalized_supply_price_usd) > 0){
    full_data[i,"btc_y2050_normalized_supply_price_usd"] <- all_assets$data$misc_data$btc_y2050_normalized_supply_price_usd
  }
  if (length(all_assets$data$misc_data$asset_created_at) > 0){
    full_data[i,"asset_created_date"] <- all_assets$data$misc_data$asset_created_at
  }
  if (length(all_assets$data$misc_data$asset_age_days) > 0){
    full_data[i,"asset_age_days"] <- all_assets$data$misc_data$asset_age_days
  }
  if (length(all_assets$data$misc_data$categories) > 0){
    full_data[i,"category"] <- all_assets$data$misc_data$categories
  }
  # if (length(all_assets$data$misc_data$sectors) > 0){
  #   full_data[i,"sector"] <- all_assets$data$misc_data$sectors
  # }
  # Lend Rates
  if (length(all_assets$data$lend_rates$bitfinex) > 0){
    full_data[i,"lend_rates_bitfinex"] <- all_assets$data$lend_rates$bitfinex
  }
  if (length(all_assets$data$lend_rates$block_fi) > 0){
    full_data[i,"lend_rates_block_fi"] <- all_assets$data$lend_rates$block_fi
  }
  if (length(all_assets$data$lend_rates$celsius) > 0){
    full_data[i,"lend_rates_celsius"] <- all_assets$data$lend_rates$celsius
  }
  # if (length(all_assets$data$lend_rates$coin_list) > 0){
  #   full_data[i,"lend_rates_coin_list"] <- all_assets$data$lend_rates$celsius
  # }
  if (length(all_assets$data$lend_rates$poloniex) > 0){
    full_data[i,"lend_rates_poloniex"] <- all_assets$data$lend_rates$poloniex
  }
  # Borrow Rates
  if (length(all_assets$data$borrow_rates$coin_list) > 0){
    full_data[i,"borrow_rates_coin_list"] <- all_assets$data$borrow_rates$coin_list
  }
  # Loan Data
  if (length(all_assets$data$loan_data$originated_last_24_hours_usd) > 0){
    full_data[i,"loans_originated_last_24_hours_usd"] <- all_assets$data$loan_data$originated_last_24_hours_usd
  }
  if (length(all_assets$data$loan_data$outstanding_debt_usd) > 0){
    full_data[i,"loans_outstanding_debt_usd"] <- all_assets$data$loan_data$originated_last_24_hours_usd
  }
  if (length(all_assets$data$loan_data$repaid_last_24_hours_usd) > 0){
    full_data[i,"loans_repaid_last_24_hours_usd"] <- all_assets$data$loan_data$repaid_last_24_hours_usd
  }
  if (length(all_assets$data$loan_data$collateralized_last_24_hours_usd) > 0){
    full_data[i,"loans_collateralized_last_24_hours_usd"] <- all_assets$data$loan_data$collateralized_last_24_hours_usd
  }
  if (length(all_assets$data$loan_data$collateral_liquidated_last_24_hours_usd) > 0){
    full_data[i,"loans_collateral_liquidated_last_24_hours_usd"] <- all_assets$data$loan_data$collateral_liquidated_last_24_hours_usd
  }
  # Reddit
  if (length(all_assets$data$reddit$active_user_count) > 0){
    full_data[i,"reddit_active_user_count"] <- all_assets$data$reddit$active_user_count
  }
  if (length(all_assets$data$reddit$subscribers) > 0){
    full_data[i,"reddit_subscribers"] <- all_assets$data$reddit$subscribers
  }
  # Profile
  if (length(all_assets$data$profile$tagline) > 0){
    full_data[i,"tagline"] <- all_assets$data$profile$tagline
  }
  if (length(all_assets$data$profile$overview) > 0){
    full_data[i,"overview"] <- all_assets$data$profile$overview
  }
  if (length(all_assets$data$profile$background) > 0){
    full_data[i,"background"] <- all_assets$data$profile$background
  }
  if (length(all_assets$data$profile$technology) > 0){
    full_data[i,"technology"] <- all_assets$data$profile$technology
  }
  if (length(all_assets$data$profile$category) > 0){
    full_data[i,"category"] <- all_assets$data$profile$category
  }
  if (length(all_assets$data$profile$sector) > 0){
    full_data[i,"sector"] <- all_assets$data$profile$sector
  }
  if (length(all_assets$data$profile$tag) > 0){
    full_data[i,"tag"] <- all_assets$data$profile$tag
  }
  if (length(all_assets$data$profile$sfarScore) > 0){
    full_data[i,"sfarScore"] <- all_assets$data$profile$sfarScore
  }
  full_data[i,"date_time"] <- Sys.time()
  full_data[i,"date"] <- substr(Sys.time(), 1, 10)
  #make pkDummy and pkey
  full_data[i,"pkDummy"] <- substr(Sys.time(), 1, 13)
  full_data[i,"pkey"] <- paste0(full_data[i,'pkDummy'], full_data[i,'symbol'])
  
}, error=function(e){})}

# filter out rows with Null name
full_data <- full_data %>% filter(is.na(name) != 1)

# write data to database
dbWriteTable(database_connection, "Messari_R", full_data, append=T)





# NOTE FOR FUTURE DEV: RUNS INTO ISSUE AND STOPS ITERATING ON #15 INSTEAD OF RUNNING ALL OF THEM ON 03/23



#### HERE PIN DATA ####
messari <- full_data
# pins::board_register_github(name = "github", repo = "predictcrypto/pins", branch = "master", token = github_PAT_pin)
# pins::pin(messari,board='github')



# Disconnect from the database
dbDisconnect(database_connection)



