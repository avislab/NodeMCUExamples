response="HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-Type: text/html\r\n\r\n"
response=response.."It's LUA file response"
if GET['name'] ~= nil then
  response=response.."<p> Parameter 'name' is <b>"..GET['name'].."</b></p>"
end
return response
