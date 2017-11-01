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

local function round(num, numDecimalPlaces)
  mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

repeat
     disp:drawXBM( 8, 0, 12, 22, xbm_data_t )
     disp:drawXBM( 7, 24, 15, 22, xbm_data_h )
     disp:drawXBM( 0, 48, 29, 22, xbm_data_p )     
     disp:setFont(u8g.font_10x20)
     disp:drawStr( 40, 16, round(weather_data.T, 1)..' C')
     disp:drawStr( 40, 38, round(weather_data.H, 0)..' %')
     disp:drawStr( 40, 60, round(weather_data.P * 0.000750061683, 0)..' mmHg')
until disp:nextPage() == false

xbm_data_t = nil
xbm_data_h = nil
xbm_data_p = nil
collectgarbage()
