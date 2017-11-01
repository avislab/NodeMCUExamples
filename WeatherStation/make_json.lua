-- Macke JSON files

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function make_json_file(file_name, last_secconds)
    local sec, usec = rtctime.get()
    local datetime = sec

    local fdr = file.open(cfg['data_file'])
    local fdw = file.open(file_name, "w")
    fdw.write('{"data":[')
    local comma = ''
    repeat
        local line = fdr:readline()
        if line then
            local field = tonumber(string.match(line, "(%w+),"))
            if field > datetime - last_secconds then
                fdw.write(comma)
                comma = ','
                line = trim(line)
                --line = string.sub(line, 1, -2)
                line = string.gsub(line ,"(.):", '"%1":')
                --line = '{"D":'..line..'}'
                line = '{'..line..'}'
                fdw.write(line)
            end
        end
    until line == nil
    fdr:close()
    fdw.write(']}')
    fdw:close()
end

--make_json_file("1h.json", 3600)
print("JSON is making...")
make_json_file("1d.json", 86400)
make_json_file("3d.json", 259200)
make_json_file("7d.json", 604800)
print("JSON OK")

collectgarbage()
