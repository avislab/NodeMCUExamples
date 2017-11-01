-- IIC init
--local sda = 3 -- GPIO14
--local scl = 4 -- GPIO12
local sla = 0x3c
--i2c.setup(0, sda, scl, i2c.SLOW)

-- Display init
disp = u8g.ssd1306_128x64_i2c(sla)
disp:begin()

-- Set Font
disp:setFont(u8g.font_10x20)
 
-- Draw a text
disp:firstPage()
repeat
  disp:drawStr(0, 32, "Welcome!")
until disp:nextPage() == false
