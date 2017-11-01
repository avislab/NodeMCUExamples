print ( "Waiting ...")
tmr.register (0, 10000, tmr.ALARM_SINGLE, function (t) tmr.unregister (0); print ( "Starting ..."); dofile ( "meteo_main.lua") end)
tmr.start (0)
