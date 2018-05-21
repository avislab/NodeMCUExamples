print ( "Waiting ...")
tmr.register (0, 10000, tmr.ALARM_SINGLE, function (t) tmr.unregister (0); print ( "Starting ..."); dofile ( "firebase_weather.lua") end)
tmr.start (0)
