-- Send data to the Internet

-- Push data to Queue file
file.open(cfg['web_queue_file'], "a")
file.writeline(weather_data_line)
file.close()      

-- Function send data and remove line from queue
local function push_data_to_url(content, key) 
  http.post(cfg['web_url'],
    'Content-Type: application/x-www-form-urlencoded\r\n',
    'id='..cfg['web_id']..'&data='..content..'&key='..key,
    function(http_code, http_data)
        if (http_code < 0) then
            print("HTTP request failed.")
        else
            print("Sent to the web OK")
              -- Remove temporary file
            local tmp_file = cfg['web_queue_file']..".tmp"
            file.remove(tmp_file)

            -- Delete line from queue
            local fdr = file.open(cfg['web_queue_file'])    
            local fdw = file.open(tmp_file, "w")
            local count_lines = 0
            repeat
            local line = fdr:readline()
            if line then
                count_lines = count_lines + 1
                if count_lines > 1 then
                    fdw:write(line)
                end
            end
            until line == nil
            fdr:close()
            fdw:close()

            file.remove(cfg['web_queue_file'])
            file.rename(tmp_file, cfg['web_queue_file'])
            queue()
        end
    end)
end

-- Function start queue processing
function queue ()
    file.open(cfg['web_queue_file'])
    local line = file.readline()
    if line then
        local field = string.match(line, "(%w+),")
        local content = crypto.toBase64(line)
        local key = crypto.toHex(crypto.encrypt("AES-ECB", cfg['web_key'], field))
        push_data_to_url(content, key);
    end
    file.close()
end

-- Start Queue processing
queue()

collectgarbage()
