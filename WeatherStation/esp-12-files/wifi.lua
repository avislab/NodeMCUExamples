--WiFi Settup
wifi.setmode(wifi.STATIONAP)
local station_cfg={}
station_cfg.ssid=cfg['wifi_ssid']
station_cfg.pwd=tostring(cfg['wifi_pwd'])
wifi.sta.config(station_cfg)
station_cfg = nil

local ap_cfg={}
ap_cfg.ssid=cfg['ap_ssid']
ap_cfg.pwd=tostring(cfg['ap_pwd'])
wifi.ap.config(ap_cfg)
ap_cfg = nil

-- Disable AP after 5 minutes
tmr.register(3, 600000, tmr.ALARM_AUTO, function()
  wifi.setmode(wifi.STATION)
end)
tmr.start(3)

collectgarbage()
