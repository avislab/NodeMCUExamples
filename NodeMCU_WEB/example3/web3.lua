-- Close old Server
if sv then
 sv:close()
end

--Create Server
sv=net.createServer(net.TCP)

function receiver(sck, data)    
  -- Print received data
  print(data)
  -- Send reply
  sck:on("sent", function(sck) sck:close() end)

  filecontent = '';
  -- read file:
  if file.open("large.html", "r") then
    filecontent = file.read()
    file.close()
  end  
  sck:send(filecontent)
end

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end
