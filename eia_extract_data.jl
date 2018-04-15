function generate_date_string(d::Date)
  if Dates.month(d) < 10
    dmonth = join(["0",Dates.month(d)])
  else
    dmonth = string(Dates.month(d))
  end

  if Dates.day(d) < 10
    dday = join(["0",Dates.day(d)])
  else
    dday = string(Dates.day(d))
  end

  date_string = join([Dates.year(d),dmonth,dday])
  return date_string
end

using JSON
function generate_data(d1::Date,d2::Date,timeframe::String)
  if timeframe != "Daily" && timeframe != "Hourly"
    error("Third argument should be \"Daily\" or \"Hourly\"")
  end
  if timeframe == "Daily"
    batchsize = 30
  else #Hourly
    batchsize = 9
  end

  foldername = join(["datafiles_",timeframe])
  if !isdir(foldername)
    mkdir(foldername)
  end

  data = Dict()
  idata = Dict()

  while (d2-d1).value+1 >= batchsize # because the interval they use is 9 days
    sd = d2 - Dates.Day(batchsize-1)
    ed = d2
    sd_string = generate_date_string(sd)
    ed_string = generate_date_string(ed)

    newfilename = joinpath(foldername,ed_string)
    if !isfile(newfilename)
      url = join(["https://www.eia.gov/realtime_grid/data/index.php?ed=",
                ed_string,
                "T23&p=",
                timeframe,
                "&sd=",
                sd_string,
                "T00&type=data"])
      datafile = download(url,newfilename)
    end
    parsedfile = JSON.parsefile(newfilename)
    datanew = parsedfile["data"]
    if "idata" in keys(parsedfile)
      idatanew = parsedfile["idata"]
      merge!(idata,idatanew)
    end

    merge!(data,datanew)

    d2 = d2 - Dates.Day(batchsize)
  end

  sd = d2 - Dates.Day(batchsize-1)
  ed = d2
  sd_string = generate_date_string(sd)
  ed_string = generate_date_string(ed)
  newfilename = joinpath(foldername,ed_string)

  # add the remaining from the 9 days
  if !isfile(newfilename)
    url = join(["https://www.eia.gov/realtime_grid/data/index.php?ed=",
              ed_string,
              "T23&p=",
              timeframe,
              "&sd=",
              sd_string,
              "T00&type=data"])
    datafile = download(url,newfilename)
  end

  parsedfile = JSON.parsefile(newfilename)
  datanew = parsedfile["data"]
  if "idata" in keys(parsedfile)
    idatanew = parsedfile["idata"]
    while d2 >= d1
      data[ed_string] = datanew[ed_string]
      idata[ed_string] = idatanew[ed_string]
      d2 = d2 - Dates.Day(1)
      ed_string = generate_date_string(d2)
    end
  else
    while d2 >= d1
      data[ed_string] = datanew[ed_string]
      d2 = d2 - Dates.Day(1)
      ed_string = generate_date_string(d2)
    end
  end
  return data,idata
end

# sample run:
# d1 = Date(2017,1,1)
# d2 = Date(2018,1,1)
#
# data2017,idata2017 = generate_data(d1,d2)

# idata is authority Interchange
# idata["<data>"]["<station>"]["<station>"]
# data["<date>"]["<station>"]["<keyword>"]
# D: Demand
# DF: Demand Forecast
# TI: balancing authority in flow and out flow

# Note: all times are in GMT.
# EST = GMT - 5 hours

# TODO: fix this to another timezone if it's very important?
# Currently, I tried figuring out a way to download the data specifying a timezone and changing Txx in the url
# Nevertheless, The start of the day is still set to 00GMT
# Maybe fix this by manually changing the times for all the data, icky but should work if needed.

