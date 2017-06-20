print("Waiting ...")
tmr.register (0, 3000, tmr.ALARM_SINGLE, function (t) tmr.unregister(0); print( "Starting ..."); gpio.mode(3, gpio.INPUT); if gpio.read(3) == 0 then dofile("http.lua") else dofile("tracker.lua") end end)
tmr.start (0)
