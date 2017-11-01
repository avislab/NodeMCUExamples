--Init BME280
--bme280.init(3, 4)
bme280.setup()

--First reading always is incorrect
local P, T = bme280.baro()
tmr.delay(100000)

collectgarbage()
