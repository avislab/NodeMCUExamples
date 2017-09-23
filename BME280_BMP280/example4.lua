function round(num, numDecimalPlaces)
  mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
 
-- IIC init
local sda = 5
local scl = 6
local sla = 0x3c
i2c.setup(0, sda, scl, i2c.SLOW)
 
--Init BME280
bme280.init(sda, scl)
--bme280.setup()
local P, T = bme280.baro()
tmr.delay(100000)
 
-- Display init
local disp = u8g.ssd1306_128x64_i2c(sla)
disp:begin()
 
-- Set Font
disp:setFont(u8g.font_10x20)
 
function read_and_show()
  local P, T = bme280.baro()
  local H, t = bme280.humi()
 
  T = T/100
  H = H/1000
 
  print (P, T, H)
 
  disp:firstPage()
 
  file.open("t.MONO", "r")
  local xbm_data_t = file.read()
  file.close()
 
  file.open("h.MONO", "r")
  local xbm_data_h = file.read()
  file.close()
 
  file.open("p.MONO", "r")
  local xbm_data_p = file.read()
  file.close()
 
  repeat
    disp:drawXBM( 8, 0, 12, 22, xbm_data_t )
    disp:drawXBM( 7, 24, 15, 22, xbm_data_h )
    disp:drawXBM( 0, 48, 29, 22, xbm_data_p )
    disp:setFont(u8g.font_10x20)
    disp:drawStr( 40, 16, round(T,1)..' C')
    disp:drawStr( 40, 38, round(H)..' %')
    disp:drawStr( 40, 60, round(P* 0.000750061683, 0)..' mmHg')
  until disp:nextPage() == false
 
  xbm_data_t = nil
  xbm_data_h = nil
  xbm_data_p = nil
  collectgarbage()
end
 
read_and_show()
-- Start timer
tmr.register(0, 5000, tmr.ALARM_AUTO, read_and_show)
tmr.start(0)

