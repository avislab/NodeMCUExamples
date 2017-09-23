-- BMP280 Example

bme280.init(5, 6)
local P, T = bme280.baro()
tmr.delay(100000)
 
local P, T = bme280.baro()
 
T = T/100
 
print (P, T)
