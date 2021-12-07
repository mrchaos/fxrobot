using Revise
include("../src/FxRobot.jl");import .FxRobot


asset = "ETHUSDT"
from = "2021-03-01"
to = "2021-03-10"
period = "1m"
out_path = "./data/csv/daily"

FxRobot.download_daily_binance_data(asset,from,to,period,out_path)

asset = "ETHUSDT"
from = "2021-01-01"
# to = string(today())
to = "2021-11-01"
period = "1m"
out_path = "./data/csv/monthly"

FxRobot.download_monthly_binance_data(asset,from,to,period,out_path)

file_regexp = r"(.*)(ETHUSDT-1m)(.*)(\.csv)"
df = FxRobot.trans_df( FxRobot.csv_to_dataframe(out_path;file_regexp=file_regexp) )


arrow_path = abspath("./data/arrow/ETHUSDT-1m-2021.arrow")
FxRobot.arrow_write(df,arrow_path)
df = FxRobot.arrow_read(arrow_path)
df
