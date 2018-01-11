-- make object & set values
local obj = {}
obj.name='Albert Fisher'
obj.phone='+380673044742'
obj.wifi={}
obj.wifi.ssid='WIFISSID'
obj.wifi.passwd='password'
obj.list={'item one', 'item two', -35, 712}

-- convert object to JSON content sctring
local json_str = sjson.encode(obj);

-- pring JSON
print(json_str);

-- rewrite JSON to file
if file.open("settings.json", "w") then
  file.write(json_str)
  file.close()
end

-- read JSON from file
if file.open("settings.json", "r") then
  -- convert JSON to object
  jobj = sjson.decode(file.read())
  file.close()
end

-- print object values
print (jobj.name)
print (jobj.phone)

print(jobj.wifi) --incorrect
print(jobj.wifi.ssid)
print(jobj.wifi.passwd)
print(jobj.list[1])
print(jobj.list[3])
