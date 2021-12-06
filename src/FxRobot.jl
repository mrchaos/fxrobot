module FxRobot
using Downloads: download
using Dates
using ZipFile: Reader
using DataFrames
using CSV
using TimeZones
using Chain
import Arrow

export
    unzip_file,ts2dt,dt2ts, # utils.jl
    csv_to_dataframe, # df.jl
    arrow_read,arrow_write, # arrow.jl
    download_monthly_binance_data, # binance.jl
    download_daily_binance_data,
    trans_df

include("utils.jl")
include("./feed/binance.jl")
include("./feed/df.jl")
include("./feed/arrow.jl")
end