-- Wi-Fi settings
--WIFI_SSID = "Ofis"
--WIFI_PWD = "AaBbCcDdEe"

-- CRON
--CRON_MASK = "*/15 * * * *"

-- Data Storage
--DADA_FILE = "log.txt"
--DADA_FILE_MAX_SIZE = 120000
--DATA_FILE_LINES = 2976

-- Send Data to the Internet
--WEB_URL = "http://avispro.com.ua/meteo/meteo.php"
--WEB_ID = 1
--WEB_KEY = "Ab$49nVG67cjk&f4"
--WEB_QUEUE_FILE = "queue.txt"
--WEB_ENABLE = true

-- thingspeak.com
--THINGSPEAK_URL = "api.thingspeak.com"
--THINGSPEAK_API_KEY = "RRX2R3OV80F9CK0C"
--THINGSPEAK_ENABLE = true

dofile('cfg.lua');

function cgf_to_json()
  local json = '{"cfg":[{';  
  for key,value in pairs(cfg) do
    json = json..'"'..key..'":"'..value..'",';
  end
  json = string.sub(json, 0, -2)..'}]}';
  return json;
end

function save_cfg(GET)
  file.open("cfg.lua", "w")
  file.writeline("cfg = {")
  for key,value in pairs(cfg) do
    if tonumber(GET[key]) == nil then
        file.writeline(key..'="'..GET[key]..'",')
    else
        file.writeline(key..'='..GET[key]..',')
    end
  end
  file.writeline("}")
  file.close()
  dofile("cfg.lua");
  return "Configuration is saved. Please reboot Metro Station.";
end
