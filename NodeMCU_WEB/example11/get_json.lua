-- make object & set values
if weather == nil then
  weather = {}
  weather.temperature=23.7
  weather.humidity=58
end
weather.timer = tmr.now()

response="HTTP/1.0 200 OK\r\nServer: NodeMCU\r\nContent-Type: application/json\r\n\r\n"
response=response..sjson.encode(weather)
return response
