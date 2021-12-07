function unzip_file(zipfile::String, out_path::String)::Nothing
  r = Reader(zipfile)
  for f in r.files
      path = joinpath(out_path,f.name)
      println(path)
      try
          write(path,read(f))
      catch e
          println(e)
      finally
          close(f) 
      end
  end
  close(r)
  nothing
end

# function HTTP response to JSON
function r2j(response)
    JSON.Parser.parse(String(response))
end

# results
function results(success::Bool,msg::String,data::Any)
    return Dict("success"=>success,"msg"=>msg,"data"=>data)
  end
  
  function results(success::Bool,msg::String)
    return Dict("success"=>success,"msg"=>msg,"data"=>nothing)
  end
  
  function results(err::Exception)
    msg = ""
    if typeof(err) == HTTP.ExceptionRequest.StatusError    
      try
        d = r2j(err.response.body)
        msg = string("[HTTP_STATUS:",err.status,", ERR_CODE:",d["code"]
          ,"] ",d["msg"])    
      catch e
        msg = string("[HTTP_STATUS:",err.status,"] ",string(err.response))      
      end    
    else
      msg = string(err)
    end
    return Dict("success"=>false,"msg"=>msg,"data"=>nothing)
  end

  # timestamp to datetime
function ts2dt(timestamp::Int64)
    unix2datetime(timestamp/1_000)
end

# datetime to timestamp
function dt2ts(dt::DateTime)
    Int64(floor(datetime2unix(dt)*1_000))
end

# yyyy-mm-dd hh:mm:ss (UTC) string to timestamp
function st2ts(st::String)
    dt = DateTime(st,dateformat"y-m-d H:M:S")
    dt2ts(dt)
end

# signing with apikey and apisecret
function timestamp()
    Int64(floor(datetime2unix(now(Dates.UTC))*1_000))
end

#local time to UTC
# yyyy-mm-dd hh:mm:ss string to UTC datetime
function local_st2utc_dt(st::String)
    zdt= ZonedDateTime(
            DateTime(st,dateformat"y-m-d H:M:S"),
            tz"Asia/Seoul"
          )
    dt = DateTime(zdt,Dates.UTC)
end

# UTC time stamp to local datetime
# timestamp (UTC) string to datetime
function utc_ts2local_dt(ts::Int64)  
    zdt= ZonedDateTime(
            ts2dt(ts),
            tz"UTC"
          )
    DateTime(
      astimezone(zdt, tz"Asia/Seoul"))
end

# dict to params
function d2p(dict::Dict)
    #?a=1&b=2 ==> a=1&b=2
    string(URIs.URI(query=dict))[2:end]
end

function sign(secret,msg)
    bytes2hex(SHA.hmac_sha256(Vector{UInt8}(secret),Vector{UInt8}(msg)))
    #Nettle.hexdigest("sha256",secret,msg)
end

function monitor_input()
  # Put STDIN in 'raw mode'
  # key input
  """
  inputBuffer = monitorInput()
  if isready(inputBuffer) && take!(inputBuffer) == 'q' 
    println("==================END!====================")
    return
  end   
  """
  ccall(:jl_tty_set_mode, Int32, (Ptr{Nothing}, Int32), stdin.handle, true) == 0 || 
        throw("FATAL: Terminal unable to enter raw mode.")

  inputBuffer = Channel{Char}(100)

  @async begin
      while true
          c = read(stdin, Char)
          put!(inputBuffer, c)
      end
  end
  return inputBuffer
end