-- configuration
dofile('config.lua')

-- initialize SD Card
dofile('sdcard.lua')

-- led pin init
gpio.mode(cfg['led_pin'], gpio.OUTPUT)

-- GPS variables
gpx_file=""
gps_time=''
gps_dst=0
gps_point={}
gps_point.lat=nil
gps_point.lat_c=''
gps_point.lon=nil
gps_point.lon_c=''

gps_point1={}
gps_point1.lat=0
gps_point1.lat_c=''
gps_point1.lon=0
gps_point1.lon_c=''

gps_tracking = false

local gpx_index_file=cfg['gpx_dir']..cfg['gpx_index_file']
local gpx_file_mask=cfg['gpx_dir']..cfg['gpx_file_mask']

local function get_gpx_filename()
  local gpx_index=0
  if file.open(gpx_index_file) then
    gpx_index=file.read()
    if gpx_index ~= nil then
      gpx_index=tonumber(gpx_index)
    else
     gpx_index=1
    end
    file.close()
    if gpx_index==nil then
      gpx_index=0
    end
  end
  gpx_index=gpx_index+1
  if file.open(gpx_index_file, "w") then
    file.write(gpx_index)
    file.close()
  end
  return string.format(gpx_file_mask, gpx_index)
end

local function round(num, numDecimalPlaces)
  local mult=10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

local function gps_convert_to_grad(gps_data)
  gps_data=gps_data/100;
  grad=round(gps_data, 0);
  min=((gps_data - grad)*100)/60;
  return grad+min;
end

uart.on("data", "\r",
  function(data)
    local data=string.gsub(data, "%s+", "")
    
    -- GPS LAT & LON
    local st,fn=string.find(data, "$GPGGA")
    if st==1 then
      data=data..','
      local gps_fields={}
      local gps_field_id=0
      for word in string.gmatch(data, "([^,]*),") do
        gps_fields[gps_field_id]=word
        gps_field_id=gps_field_id+1
      end
      if tonumber(gps_fields[2])~=nil then
        gps_point.lat=gps_convert_to_grad(tonumber(gps_fields[2]))
        gps_point.lat_c=gps_fields[3]
        gps_point.lon=gps_convert_to_grad(tonumber(gps_fields[4]))
        gps_point.lon_c=gps_fields[5]
      else
        gps_point.lat=nil
        gps_point.lon=nil
      end
    end

    --GPS Date & Time
    local st,fn=string.find(data, "$GPRMC")
    if st==1 then
      local gps_dt={}
      local gps_dt_id=0
      for word in string.gmatch(data, "([^,]*),") do
        gps_dt[gps_dt_id]=word
        gps_dt_id=gps_dt_id+1
      end
      local time=0
      local date=0
      if gps_dt[1] ~= '' then
        time=tonumber(gps_dt[1])
      end
      if gps_dt[9] ~= '' then
        date=tonumber(gps_dt[9])
      end
      local h=math.floor(time/10000, 0)
      local m=math.floor((time-h*10000)/100, 0)
      local s=math.floor(time-h*10000 - m*100, 0)
      local D=math.floor(date/10000, 0)
      local M=math.floor((date-D*10000)/100, 0)
      local Y=2000+math.floor(date-D*10000 - M*100, 0)
      gps_time=string.format("%d-%02d-%02dT%02d:%02d:%02dZ",Y,M,D,h,m,s)
    end
end, 0)

local function gps_track()
  if gps_tracking then
    if gps_point.lat~=nil then
      gps_dst = dofile('distance.lua')
      if gps_dst > cfg['gpx_distance'] then
        if file.open(gpx_file, "a+") then
          file.write("<trkpt lat=\""..gps_point.lat.."\" lon=\""..gps_point.lon.."\">\r\n<time>"..gps_time.."</time>\r\n</trkpt>\r\n")
          gps_point1.lat = gps_point.lat
          gps_point1.lat_c = gps_point.lat_c
          gps_point1.lon = gps_point.lon
          gps_point1.lon_c = gps_point.lon_c
          file.close()
          gpio.serout (cfg['led_pin'], gpio.LOW, {50000,50000}, 1, 1)
        end
      end
    end
  end
end

-- start timer
tmr.register(0, cfg['gpx_period']*1000, tmr.ALARM_AUTO, gps_track)
tmr.start(0)

-- button
local function btn_down(level, pulse2)
  gps_tracking=not gps_tracking
  if gps_tracking then
    print("On")
    gps_point1.lat=0
    gps_point1.lon=0    
    gpio.serout (cfg['led_pin'], gpio.LOW, {99000,99000}, 2, 1)
    gpx_file=get_gpx_filename()
    if file.open(gpx_file, "w+") then
      file.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\" ?>\r\n<gpx>\r\n<trk>\r\n<trkseg>\r\n")
      file.close()
    else
      gps_tracking=not gps_tracking
    end
  else
    print("Off")
    gpio.serout (cfg['led_pin'], gpio.LOW, {99000,99000}, 1, 1)
    if file.open(gpx_file, "a+") then
        file.write("</trkseg>\r\n</trk>\r\n</gpx>\r\n")
        file.close()
        gpx_file=''
    end
  end
  tmr.delay(500000) --0.5s
end

-- button init
gpio.mode(3, gpio.INT)
gpio.trig(3, "down", btn_down)

gpio.serout (cfg['led_pin'], gpio.LOW, {99000,99000}, 2, 1)
print("Tracker started.")
