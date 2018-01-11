-- Close old Server
if sv then
 sv:close()
end

--Create HTTP Server
sv=net.createServer(net.TCP)

function receiver(sck, data)
  -- Print received data
  print(data)
  
  local response = {"<html>"}
  response[#response+1]="<title>NodeMCU</title>"
  response[#response+1]="<body>"
  response[#response+1]="<h1>NodeMCU</h1>"
  response[#response+1]="<hr>"
  response[#response+1]="Hello world! It is a BIG HTML file 'index1.html'"
  response[#response+1]="</body>"
  response[#response+1]="</html>"
  response[#response+1]="<p>1 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>2 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>3 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>4 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>5 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>6 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>7 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>8 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>9 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>10 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>11 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>12 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>13 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>14 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>15 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>16 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>17 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>18 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>19 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>20 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>21 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>22 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>23 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>24 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>25 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>26 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>27 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>28 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>29 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>30 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>31 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>32 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>33 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>34 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>35 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>36 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>37 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>38 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>39 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="<p>40 Something big Something big Something big Something big Something big Something big</p>"
  response[#response+1]="</body>"
  response[#response+1]="</html>"
  
  -- sends and removes the first element from the 'response' table
  local function send(localSocket)
    if #response > 0 then
      localSocket:send(table.remove(response, 1))
    else
      localSocket:close()
      response = nil
    end
  end

  -- triggers the send() function again once the first chunk of data was sent
  sck:on("sent", send)

  send(sck)
end

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end
