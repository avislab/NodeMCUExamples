--Create Server
sv=net.createServer(net.TCP)

function receiver(sck, data)    
  -- Print received data
  print(data)
  -- Send response
  sck:on("sent", function(sck) sck:close() end)
  sck:send("HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-Type: text/html\r\n\r\n"..
     "<html><title>NodeMCU</title><body>"..
     "<h1>NodeMCU</h1>"..
     "<hr>"..
     "Hello world!"..
     "<p>Time: "..tmr.now().."</p>"..
     "</body></html>")
end

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end
