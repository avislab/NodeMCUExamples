response="HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-Type: text/html\r\n\r\n"
response=response.."It's LUA file response"
if POST['name'] ~= nil then
  response=response.."<p> Parameter 'name' is <b>"..POST['name'].."</b></p>"
  response=response.."<p> Parameter 'phone' is <b>"..POST['phone'].."</b></p>"
end
return response
