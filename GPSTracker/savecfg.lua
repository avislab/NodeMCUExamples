-- check and apply configuration
if string.find(GET['gpx_file_mask'], '/') ~= 1 then
  return '"Name mask" is bad. First symbol must be "/"'
end

if string.find(GET['gpx_file_mask'], "%d", 1, true) == nil then
  return '"Name mask" is bad. Must contain symbols "%d"'
end

if GET['gpx_file_mask']:match("^.+(%..+)$") ~= '.gpx' then
  return '"Name mask" is bad. File extension must be ".gpx"'
end

if GET['gpx_period'] == '' or GET['gpx_period'] == nil then
  return 'Period is not specified'
end

if tonumber(GET['gpx_period']) < 1 or tonumber(GET['gpx_period']) > 3600 then
  return 'Period out of range'
end

if GET['gpx_distance'] == '' or GET['gpx_distance'] == nil then
  return 'Distance is not specified'
end

if tonumber(GET['gpx_distance']) < 1 or tonumber(GET['gpx_distance']) > 1000 then
  return 'Distance out of range'
end

cfg['gpx_file_mask']=GET['gpx_file_mask']
cfg['gpx_period']=GET['gpx_period']
cfg['gpx_distance']=GET['gpx_distance']
cfg['wifi_sid']=GET['wifi_sid']
cfg['wifi_passwd']=GET['wifi_passwd']

-- Save configuration to cfg.lua
if file.open('/FLASH/cfg.lua', "w") then
  file.writeline("-- User-modified configuration")
  file.writeline("cfg['gpx_file_mask']='"..cfg['gpx_file_mask'].."'")
  file.writeline("cfg['gpx_period']="..cfg['gpx_period'])
  file.writeline("cfg['gpx_distance']="..cfg['gpx_distance'])
  file.writeline("cfg['wifi_sid']='"..cfg['wifi_sid'].."'")
  file.writeline("cfg['wifi_passwd']='"..cfg['wifi_passwd'].."'")
  file.close()
end

-- Save gpx index file
local gpx_index = GET['gpx_index']
local gpx_index_file=cfg['gpx_dir']..cfg['gpx_index_file']
if file.open(gpx_index_file, "w") then
  file.write(gpx_index)
  file.close()
end

return "Saved successfully"
