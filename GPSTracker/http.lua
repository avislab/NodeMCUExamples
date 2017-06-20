-- configuration
dofile('config.lua')
-- initialize SD Card
dofile('sdcard.lua')
-- WiFi
dofile('wifi.lua')
-- led pin init
gpio.mode(cfg['led_pin'], gpio.OUTPUT)

http=net.createServer(net.TCP)

function receive_http(sck, data)
  -- sendfile class
  local sendfile = {}
  sendfile.__index = sendfile
  function sendfile.new(sck, fname)
    local self = setmetatable({}, sendfile)
    self.sck = sck
    self.fd = file.open(fname, "r")
    if self.fd then
      local function send(localSocket)
        local response = self.fd:read(1024)
        if response then
          localSocket:send(response)
        else
          if self.fd then
            self.fd:close()
          end
          localSocket:close()
          self = nil
        end
      end
      self.sck:on("sent", send)
      send(self.sck)
    else
      localSocket:close()
    end
    return self
  end
  -----
  
  local url_file = string.match(data,"[^/]*\/([^ ?]*)[ ?]",1)
  local uri=string.match(data,"[^?]*\?([^ ]*)[ ]",1)

  GET={}
  if uri then
    for key, value in string.gmatch(uri, "([^=&]*)=([^&$]*)") do
     GET[key]=value
    end
  end

  --print(data)
  --print(url_file)
  --print('-----------')

  if url_file == '' then
    -- gpx file deletion
    if GET['delete'] ~=nil then
      if (GET['delete']:match("^.+(%..+)$") == '.gpx') then
        local delfile=cfg['gpx_dir']..'/'..GET['delete']
        if file.exists(delfile) then
          file.remove(delfile)
          delfile=nil
        end
      end
    end
    dofile('makeindex.lua')
    sendfile.new(sck, cfg['gpx_dir']..'/index.html')
  else
    local fext=url_file:match("^.+(%..+)$")
    if fext == '.html' or fext == '.png' then
      sendfile.new(sck, '/FLASH/'..url_file)
    end
    if fext == '.gpx' then
      sendfile.new(sck, cfg['gpx_dir']..'/'..url_file)
    end
    if fext == '.lua' then
      response=dofile('/FLASH/'..url_file)
      sck:on("sent", function() sck:close() end)
      sck:send(response)
    end
  end
end
 
if http then
  http:listen(80, function(conn)
    conn:on("receive", receive_http)
  end)
end

-- button
function btn_down(level, pulse2)
  gpio.serout (cfg['led_pin'], gpio.LOW, {99000,99000}, 4, 1)
  --WiFi AP Settup
  wifi.setmode(wifi.STATIONAP)
  wificfg={}
  wificfg.ssid="ESPWIFI"
  wificfg.pwd="1234567890"
  wifi.ap.config(wificfg)
  wificfg = nil
  collectgarbage()
  print("WiFi AP Started.")
end

-- button init
gpio.mode(3, gpio.INT, gpio.PULLUP)
gpio.trig(3, "down", btn_down)

gpio.serout (cfg['led_pin'], gpio.LOW, {99000,99000}, 4, 1)
print("Http started.")
