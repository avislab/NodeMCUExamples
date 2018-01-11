--WiFi Settup
wifi.setmode(wifi.STATION)
local cfg={}
cfg.ssid="WiFiSSID"
cfg.pwd="password"
wifi.sta.config(cfg)
cfg = nil
collectgarbage()
