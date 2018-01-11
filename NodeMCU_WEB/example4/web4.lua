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

  response = "<html>"..
"  <title>NodeMCU</title>"..
"<body>"..
"<h1>NodeMCU</h1>"..
"<hr>"..
"Hello world! It is a BIG HTML file 'index1.html'"..
"<p>1 Something big Something big Something big Something big Something big Something big</p>"..
"<p>2 Something big Something big Something big Something big Something big Something big</p>"..
"<p>3 Something big Something big Something big Something big Something big Something big</p>"..
"<p>4 Something big Something big Something big Something big Something big Something big</p>"..
"<p>5 Something big Something big Something big Something big Something big Something big</p>"..
"<p>6 Something big Something big Something big Something big Something big Something big</p>"..
"<p>7 Something big Something big Something big Something big Something big Something big</p>"..
"<p>8 Something big Something big Something big Something big Something big Something big</p>"..
"<p>9 Something big Something big Something big Something big Something big Something big</p>"..
"<p>10 Something big Something big Something big Something big Something big Something big</p>"..
"<p>11 Something big Something big Something big Something big Something big Something big</p>"..
"<p>12 Something big Something big Something big Something big Something big Something big</p>"..
"<p>13 Something big Something big Something big Something big Something big Something big</p>"..
"<p>14 Something big Something big Something big Something big Something big Something big</p>"..
"<p>15 Something big Something big Something big Something big Something big Something big</p>"..
"<p>16 Something big Something big Something big Something big Something big Something big</p>"..
"<p>17 Something big Something big Something big Something big Something big Something big</p>"..
"<p>18 Something big Something big Something big Something big Something big Something big</p>"..
"<p>19 Something big Something big Something big Something big Something big Something big</p>"..
"<p>20 Something big Something big Something big Something big Something big Something big</p>"..
"<p>21 Something big Something big Something big Something big Something big Something big</p>"..
"<p>22 Something big Something big Something big Something big Something big Something big</p>"..
"<p>23 Something big Something big Something big Something big Something big Something big</p>"..
"<p>24 Something big Something big Something big Something big Something big Something big</p>"..
"<p>25 Something big Something big Something big Something big Something big Something big</p>"..
"<p>26 Something big Something big Something big Something big Something big Something big</p>"..
"<p>27 Something big Something big Something big Something big Something big Something big</p>"..
"<p>28 Something big Something big Something big Something big Something big Something big</p>"..
"<p>29 Something big Something big Something big Something big Something big Something big</p>"..
"<p>30 Something big Something big Something big Something big Something big Something big</p>"..
"<p>31 Something big Something big Something big Something big Something big Something big</p>"..
"<p>32 Something big Something big Something big Something big Something big Something big</p>"..
"<p>33 Something big Something big Something big Something big Something big Something big</p>"..
"<p>34 Something big Something big Something big Something big Something big Something big</p>"..
"<p>35 Something big Something big Something big Something big Something big Something big</p>"..
"<p>36 Something big Something big Something big Something big Something big Something big</p>"..
"<p>37 Something big Something big Something big Something big Something big Something big</p>"..
"<p>38 Something big Something big Something big Something big Something big Something big</p>"..
"<p>39 Something big Something big Something big Something big Something big Something big</p>"..
"<p>40 Something big Something big Something big Something big Something big Something big</p>"..
"</body>"..
"</html>"
 
  sck:send(response)
end

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
  end)
end
