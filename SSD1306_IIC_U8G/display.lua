-- IIC init
local sda = 3 -- GPIO14
local scl = 4 -- GPIO12
local sla = 0x3c
i2c.setup(0, sda, scl, i2c.SLOW)

-- Display init
disp = u8g.ssd1306_128x64_i2c(sla)
disp:begin()

-- Set Font
disp:setFont(u8g.font_10x20)

-- Draw a text
disp:firstPage()
repeat 
  disp:drawStr(0, 16, "I's just")
  disp:drawStr(0, 32, "a test.")
until disp:nextPage() == false

tmr.delay(2000000)

-- Draw
disp:firstPage()
repeat 
  disp:drawLine(0,0,127,64);
  disp:drawLine(0,64,127,0);
  disp:drawFrame(10,10,40,40);
  disp:drawCircle(100,20,20);
  disp:drawTriangle(60,60, 80,55, 70,40);
until disp:nextPage() == false

tmr.delay(2000000)

-- Read a picture #1
file.open("example1.MONO", "r")
local xbm_data_t = file.read()
file.close()
-- Draw a picture #1
disp:firstPage()
repeat 
  disp:drawXBM(26, 0, 76, 64, xbm_data_t)
until disp:nextPage() == false

tmr.delay(2000000)

-- Read a picture #2
file.open("example2.MONO", "r")
local xbm_data_t = file.read()
file.close()
-- Draw a picture #2
disp:firstPage()
repeat 
  disp:drawXBM(32, 0, 64, 64, xbm_data_t)
until disp:nextPage() == false

collectgarbage()
