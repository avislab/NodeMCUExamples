response="HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-Type: application/json\r\n\r\n"
if POST['data'] ~= nil then
  local data = sjson.decode(POST['data'])
  if data.name == nil or data.name == '' then
    response=response..'{"result": "Error. Name is empty"}'
  else
    if data.phone == nil or data.phone == '' then
      response=response..'{"result": "Error. Phone is empty"}'
    else
      -- save data to JSON file
      if file.open("settings.json", "w") then
        file.write(POST['data'])
        file.close()
      end
      response=response..'{"result": "OK"}'
    end
  end
end
return response
