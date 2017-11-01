local P, T = bme280.baro()
local H, t = bme280.humi()

weather_data.P = P
weather_data.T = T/100
weather_data.H = H/1000

-- get current datetime
local sec, usec = rtctime.get()
weather_data.D = sec

collectgarbage()
