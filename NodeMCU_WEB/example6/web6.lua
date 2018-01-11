-- Close old Server
if sv then
 sv:close()
end

--Create HTTP Server
sv=net.createServer(net.TCP)

function receiver(sck, data)    
  -- Print received data
  print(data)
  
  fd = file.open("large.html", "r")
  if fd then
    local function send(localSocket)
      local response = fd:read(512)
      if response then
        localSocket:send(response)
      else
        if fd then
          fd:close()
        end
        localSocket:close()
      end
    end
    sck:on("sent", send)
    send(sck)
  else
      localSocket:close()
  end
end

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end
