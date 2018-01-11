-- Close old Server
if httpd then
 httpd:close()
end

httpd=net.createServer(net.TCP)

-- decode URI
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

  -- parse GET parameters
  GET={}
  if uri then
    for key, value in string.gmatch(uri, "([^=&]*)=([^&]*)") do
     GET[key]=value
     print(key, value)
    end
  end

  -- parse POST parameters
  local post = string.match(data,"\n([^\n]*)$",1):gsub("+", " ")
  POST={}
  if post then
    for key, value in string.gmatch(post, "([^=&]*)=([^&]*)") do
     POST[key]=decodeURI(value)
     print(key, POST[key])
    end
  end  

  print("HTTP request:", data)

  request_OK = false

  -- if file not specified then send index.html
  if url_file == '' then
    sendfile.new(sck, 'index.html')
    request_OK = true
  else
    local fext=url_file:match("^.+(%..+)$")
    if fext == '.html' or
       fext == '.txt' or
       fext == '.js' or
       fext == '.json' or
       fext == '.css' or
       fext == '.png' or
       --fext == '.gif' or
       fext == '.ico' then
       if file.exists(url_file) then
           sendfile.new(sck, url_file)
           request_OK = true
       end
    end

    -- execute LUA file
    -- IT IS HAZARDOUS
    if fext == '.lua' then
      if file.exists(url_file) then
        response=dofile(url_file)
        sck:on("sent", function() sck:close() end)
        sck:send(response)
        request_OK = true
      end
    end
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
