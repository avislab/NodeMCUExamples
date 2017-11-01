local tm = rtctime.epoch2cal(rtctime.get())
--If time not synchronized
if tm["year"] < 2017 then
  sntp.sync()
else 
  dofile("BME280_read.lua")
  weather_data_line = 'D:'..weather_data.D..',T:'..weather_data.T..',P:'..weather_data.P..',H:'..weather_data.H
  dofile("write_to_file.lua")
  print("Dataline:", weather_data_line)

  if cfg['web_enable'] == 1 then
    dofile("send_to_web.lua")
  end

  if cfg['thingspeak_enable'] == 1 then
    dofile("send_to_thingspeak.lua")
  end

  tmr.register(2, 5000, tmr.ALARM_SINGLE, function()  dofile("make_json.lua") end)
  tmr.start(2)
end
collectgarbage()
