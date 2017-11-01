-- Read settings
dofile("settings.lua")

-- Init Wifi
dofile("wifi.lua")

-- Global Variables
weather_data = {D=0, P=0, T=0, H=0}

-- IIC init
local sda = 0 -- GPIO0
local scl = 2 -- GPIO2
--local sla = 0x3c
i2c.setup(0, sda, scl, i2c.SLOW)

-- BME280 init
dofile("BME280_init.lua")
dofile("BME280_read.lua")

-- Init Display
dofile('display_init.lua')
dofile('display_show.lua')

-- Start timer
tmr.register(1, 10000, tmr.ALARM_AUTO, function()
  dofile("BME280_read.lua");
  dofile('display_show.lua')
end)
tmr.start(1)

-- Sheduler
rtctime.set(1436430589, 0)
cron.schedule(cfg['cron_mask'], function(e)
  dofile("schedule.lua")
end)

--Start HTTP 'server'
dofile('httpd.lua')
print('Ready')
