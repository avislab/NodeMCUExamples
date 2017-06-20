spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)

cfg['gpx_dir']='/SD0'
vol = file.mount("/SD0", 8)
if not vol then
  print("retry mounting")
  vol = file.mount("/SD0", 8)
  if not vol then
    cfg['gpx_dir']='/FLASH'
  end
end
