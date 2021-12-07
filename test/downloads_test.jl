using Revise
include("../src/FxRobot.jl");import .FxRobot as fx


asset = "ETHUSDT"
from = "2021-03-01"
to = "2021-03-10"
period = "1m"
out_path = "./data/csv/daily"

fx.download_daily_binance_data(asset,from,to,period,out_path)

asset = "ETHUSDT"
from = "2021-01-01"
# to = string(today())
to = "2021-11-01"
period = "1m"
out_path = "./data/csv/monthly"

fx.download_monthly_binance_data(asset,from,to,period,out_path)

file_regexp = r"(.*)(ETHUSDT-1m)(.*)(\.csv)"
df = fx.trans_df( fx.csv_to_dataframe(out_path;file_regexp=file_regexp) )

arrow_path = abspath("./data/arrow/ETHUSDT-1m-2021.arrow")
fx.arrow_write(df,arrow_path)
df = fx.arrow_read(arrow_path)
df
