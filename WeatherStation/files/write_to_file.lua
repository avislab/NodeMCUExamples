-- Save data to file
file.open(cfg['data_file'], "a")
file.writeline(weather_data_line)
file.close()

local fstat = file.stat(cfg['data_file'])
if fstat['size'] > cfg['data_file_max_size'] then
    print(fstat['size'])
    -- Preparing to Reduce file
    local count_lines = 0
    file.open(cfg['data_file'])
    repeat
      line = file.readline()
      if line then
        count_lines = count_lines + 1
      end
    until line == nil
    file.close()

    -- Reduce file
    local start_line = count_lines - cfg['data_file_lines']

    -- Remove temporary file
    local tmp_file = cfg['data_file']..".tmp"
    file.remove(tmp_file)

    -- Begin reducing
    count_lines = 0
    fdr = file.open(cfg['data_file'])    
    fdw = file.open(tmp_file, "w")
    repeat
      line = fdr:readline()
      if line then
        count_lines = count_lines + 1
        if count_lines > start_line then
            fdw:write(line)
        end
      end
    until line == nil
    fdr:close()
    fdw:close()

    fstat = file.stat(tmp_file)
    if fstat['size'] > 0 then
        file.remove(cfg['data_file'])
        file.rename(tmp_file, cfg['data_file'])
    end
    
end

collectgarbage()
