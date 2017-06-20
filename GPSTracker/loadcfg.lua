--Read gpx index file
local gpx_index_file=cfg['gpx_dir']..cfg['gpx_index_file']
if file.open(gpx_index_file) then
  gpx_index=file.read()
  if gpx_index ~= nil then
    gpx_index=tonumber(gpx_index)
  else
   gpx_index=1
  end

  file.close()
  if gpx_index==nil then
    gpx_index=0
  end
else
  gpx_index=0
end

return cfg['gpx_file_mask']..','..gpx_index..','..cfg['gpx_period']..','..cfg['gpx_distance']..','..cfg['wifi_sid']..','..cfg['wifi_passwd']
