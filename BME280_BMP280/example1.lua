-- BME280 Example

bme280.init(5, 6)
local P, T = bme280.baro()
tmr.delay(100000)
 
local P, T = bme280.baro()
local H, t = bme280.humi()
 
T = T/100
H = H/1000
 
print (P, T, H)
