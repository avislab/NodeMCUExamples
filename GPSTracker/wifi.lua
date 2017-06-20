--WiFi Settup
wifi.setmode(wifi.STATION)
local wificfg={}
wificfg.ssid=cfg['wifi_sid']
wificfg.pwd=cfg['wifi_passwd']
wifi.sta.config(wificfg)
wificfg = nil
collectgarbage()
