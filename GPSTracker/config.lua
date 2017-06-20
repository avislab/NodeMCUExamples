-- default configuration
cfg={}
cfg['gpx_file_mask']='/track%d.gpx'
cfg['gpx_period']=5
cfg['gpx_distance']=10

cfg['wifi_sid']='WIFISSID'
cfg['wifi_passwd']='password'

cfg['led_pin']=4
cfg['gpx_dir']='/SD0'
cfg['gpx_index_file']='/track_index'

-- User-modified configuration
dofile('cfg.lua')
