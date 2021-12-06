
# Binance Data URL : https://data.binance.vision/
# https://data.binance.vision/data/spot/daily/klines/ETHUSDT/1m/ETHUSDT-1m-2021-12-04.zip
# https://data.binance.vision/data/spot/monthly/klines/ETHUSDT/1m/ETHUSDT-1m-2019-03.zip
# https://www.binance.com/en/landing/data
# https://github.com/binance/binance-public-data/

# --------------------
# Data Header
# --------------------
# t : Open time
# o : Open
# h : High
# l : Low
# c : Close
# v : Volume
# T : Close time
# q : Quote asset volume
# n : Number of trades
# V : Taker buy base asset volume
# Q : Taker buy quote asset volume
# B : Ignore

function download_monthly_binance_data(asset::String,from::String,to::String,period::String,out_path::String)::Nothing
    filename::String = ""
    url::String = ""
    for m in collect(Date(from):Month(1):Date(to))
        filename = join([asset,"-",period,"-",string(m)[1:7],".zip"])
        url = join(["https://data.binance.vision/data/spot/monthly/klines/",
                            asset,"/",period,"/",filename])                        
        try
            path = joinpath(out_path,filename)
            download(url,path)
            unzip_file(path,out_path)
            rm(path)
        catch
        end
    end
    nothing
end
function download_daily_binance_data(asset::String,from::String,to::String,period::String,out_path::String)::Nothing
    filename::String = ""
    url::String = ""
    for m in collect(Date(from):Day(1):Date(to))
        filename = join([asset,"-",period,"-",string(m),".zip"])
        url = join(["https://data.binance.vision/data/spot/daily/klines/",
                            asset,"/",period,"/",filename])                        
        try
            path = joinpath(out_path,filename)
            download(url,path)
            unzip_file(path,out_path)
            rm(path)
        catch
        end
    end
    nothing
end

function trans_df(df::DataFrame)::DataFrame
    colnames=[:t,:o,:h,:l,:c,:v,:T,:q,:n,:V,:Q,:B]
    tc1=[:t,:T]
    tc2=[:opentime,:closetime]
    @chain df begin
        rename!(colnames)
        transform!(tc1.=>(t->ts2dt.(t)).=>tc2)
    end
end