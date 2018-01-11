response="HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-Type: text/html\r\n\r\n"
response=response.."It's LUA file response"
if POST['name'] ~= nil then
  response=response.."<p> Parameter 'name' is <b>"..POST['name'].."</b></p>"
  response=response.."<p> Parameter 'phone' is <b>"..POST['phone'].."</b></p>"

  -- save data to JSON file
  local json_str = sjson.encode(POST);
  if file.open("settings.json", "w") then
    file.write(json_str)
    file.close()
  end
end
return response
