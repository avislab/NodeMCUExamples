--WiFi Settup
--wifi.setmode(wifi.STATION)
--local cfg={}
--cfg.ssid="WiFiSSID"
--cfg.pwd="WiFiPassword"
--wifi.sta.config(cfg)
--cfg = nil
--collectgarbage()

-- Firebase settings
FB_APIKEY = "ApiKey"
FB_EMAIL = "email@mydomain.com"
FB_PASSWORD = "password"
FB_PROJECT = "https://mytestproject.firebaseio.com/weather.json?auth="

-- Global Variables
weather_data = {D=0, P=0, T=0, H=0}
firebaseIdToken = ''

function firebaseAuth(resend)
  uri = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key="..FB_APIKEY
  data = '{"email":"'..FB_EMAIL..'","password":"'..FB_PASSWORD..'","returnSecureToken":true}'

  http.post(uri,
    'Content-Type: application/json\r\n',
    data,
    function(http_code, http_data)
        print (http_code)
        response = sjson.decode(http_data)
        firebaseIdToken = response['idToken']
        if resend == true then
          firebaseSendData()
        end
    end)
end

function firebaseSendData()
  print('Sending...')
  http.post(FB_PROJECT..firebaseIdToken,
            'Content-Type: application/json\r\nConnection: close\r\n',
            '{"D":'..weather_data.D..', "T":'..weather_data.T..', "P":'..weather_data.P..', "H":'..weather_data.H..'}',
    function(http_code, http_data)
      print(http_code)
      print(http_data)
      -- if idToken is expired
      if (http_code == 401) then
        firebaseAuth(true)
      end
    end
  )
end

sntp.sync()
firebaseAuth(false)

-- IIC init
local sda = 3 -- GPIO14
local scl = 4 -- GPIO12
--local sla = 0x3c
i2c.setup(0, sda, scl, i2c.SLOW)

--Init BME280
bme280.setup()
--First reading always is incorrect
local P, T = bme280.baro()
tmr.delay(100000)

cron.schedule("*/5 * * * *", function(e)
  print('Sheduler')

  -- get current datetime
  local sec, usec = rtctime.get()
  
  -- if time is synchronized
  if sec > 1514764800 then
    weather_data.D = sec

    local P, T = bme280.baro()
    local H, t = bme280.humi()

    weather_data.P = P
    weather_data.T = T/100
    weather_data.H = H/1000
  
    firebaseSendData()
  end
end)


