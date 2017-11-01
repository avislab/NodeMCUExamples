httpd=net.createServer(net.TCP)

function decodeURI(s)
    if(s) then
        s = string.gsub(s, '%%(%x%x)', 
        function (hex) return string.char(tonumber(hex,16)) end )
    end
    return s
end

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
        local response = self.fd:read(128)
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
  local host_name = string.match(data,"Host: ([0-9,\.]*)\r",1)
  local url_file = string.match(data,"[^/]*\/([^ ?]*)[ ?]",1)
  local uri = decodeURI(string.match(data,"[^?]*\?([^ ]*)[ ]",1))

  GET={}
  if uri then
    for key, value in string.gmatch(uri, "([^=&]*)=([^&]*)") do
     GET[key]=value
     --print(key, value)
    end
  end

  print("HTTP request:", url_file)

  request_OK = false
  
  if host_name == '192.168.4.1' then
    admin_mode = true
  else
    admin_mode = false
  end

  if url_file == '' then
    if admin_mode then
        sendfile.new(sck, 'settings.html')
    else
        sendfile.new(sck, 'index.html')
    end
    request_OK = true
  else
    if admin_mode then
        if url_file == 'loadcfg' then
            sck:on("sent", function() sck:close() end)
            local response = cgf_to_json()
            sck:send(response)
            request_OK = true
        end

        if url_file == 'savecfg' then
            sck:on("sent", function() sck:close() end)
            local response = save_cfg(GET)
            sck:send(response)
            request_OK = true
        end
    end
  
    local fext=url_file:match("^.+(%..+)$")
    if fext == '.html' or
       fext == '.txt' or
       fext == '.js' or
       fext == '.json' or
       fext == '.css' or
       fext == '.ico' then
        if file.exists(url_file) then
            sendfile.new(sck, url_file)
            request_OK = true
        end
    end
    if url_file == 'now' then
        sck:on("sent", function() sck:close() end)
        local response = '{"data":[{"D":'..weather_data.D..',"T":'..weather_data.T..', "P":'..weather_data.P..', "H":'..weather_data.H..'}]}'
        sck:send(response)
        request_OK = true
    end

    --if fext == '.lua' then
    --  response=dofile(url_file)
    --  sck:on("sent", function() sck:close() end)
    --  sck:send(response)
    --  request_OK = true
    --end
  end

  if request_OK == false then
    sck:on("sent", function() sck:close() end)
    sck:send('Something wrong')
  end
end
 
if httpd then
  httpd:listen(80, function(conn)
    conn:on("receive", receive_http)
  end)
end

