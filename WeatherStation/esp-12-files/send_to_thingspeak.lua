-- Send data to site thingspeak.com 
-- andre@avislab.com Jaga123Jaga321

local function postThingSpeak(api_key, data)
    local connout = nil
    local connout = net.createConnection(net.TCP, 0)
 
    connout:on("receive", function(connout, payloadout)
        if (string.find(payloadout, "Status: 200 OK") ~= nil) then
            print("Sent to thingspeak.com OK");
        end
    end)
 
    connout:on("connection", function(connout, payloadout)
 
        --print ("Posting...");
 
        connout:send("GET /update?api_key="..api_key.."&"..data
        .. " HTTP/1.1\r\n"
        .. "Host: api.thingspeak.com\r\n"
        .. "Connection: close\r\n"
        .. "Accept: */*\r\n"
        .. "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n"
        .. "\r\n")
    end)
 
    connout:on("disconnection", function(connout, payloadout)
        --connout:close();
        collectgarbage();
    end)
 
    connout:connect(80,cfg['thingspeak_url'])
end

postThingSpeak(cfg['thingspeak_api_key'], 'field1='..weather_data.T..'&field2='..weather_data.P..'&field3='..weather_data.H)

collectgarbage()
