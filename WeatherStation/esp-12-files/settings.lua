dofile('cfg.lua');

function cgf_to_json()
  local json = '{"cfg":[{';  
  for key,value in pairs(cfg) do
    json = json..'"'..key..'":"'..value..'",';
  end
  json = string.sub(json, 0, -2)..'}]}';
  return json;
end

function save_cfg(GET)
  file.open("cfg.lua", "w")
  file.writeline("cfg = {")
  for key,value in pairs(cfg) do
    if tonumber(GET[key]) == nil then
        file.writeline(key..'="'..GET[key]..'",')
    else
        file.writeline(key..'='..GET[key]..',')
    end
  end
  file.writeline("}")
  file.close()
  dofile("cfg.lua");
  return "Configuration is saved. Please reboot Metro Station.";
end
