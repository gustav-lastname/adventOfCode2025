local input = {}
for line in io.lines('input.txt') do
    table.insert(input, line)
end

local devices = {}
for _, line in ipairs(input) do
    devices[line:sub(1,3)] = {connections = {}}
end

devices['out'] = {connections = {}}

for _, line in ipairs(input) do
    local device = line:sub(1,3)
    for connection_point in string.gmatch(line, '%s(%a+)') do
        table.insert(devices[connection_point].connections, device)
    end
end

local segments = {
    {'out', 'dac', 'od'},
    {'out', 'fft', 'of'},
    {'dac', 'svr', 'ds'},
    {'fft', 'svr', 'fs'},
    {'dac', 'fft', 'df'},
    {'fft', 'dac', 'fd'},
}

for _, segment in ipairs(segments) do
    local path = {{device = segment[1], direction = 1}}
    while true do
        local step = path[#path]
        if devices[step.device].connections[step.direction] == nil then
            table.remove(path)
            if #path == 0 then break end
            path[#path].direction = path[#path].direction + 1
            devices[path[#path].device][segment[3]] = (devices[path[#path].device][segment[3]] or 0) + (devices[step.device][segment[3]] or 0)
        elseif devices[step.device].connections[step.direction] == segment[2] then
            devices[step.device][segment[3]] = 1
            table.remove(path)
            path[#path].direction = path[#path].direction + 1
            devices[path[#path].device][segment[3]] = (devices[path[#path].device][segment[3]] or 0) + devices[step.device][segment[3]]
        else
            local next = devices[devices[step.device].connections[step.direction]]
            if next[segment[3]] then
                devices[step.device][segment[3]] = (devices[step.device][segment[3]] or 0) + next[segment[3]]
                step.direction = step.direction + 1
            else
                table.insert(path, {device = devices[step.device].connections[step.direction], direction = 1})
            end
        end
    end
end

local path_amount = devices['out']['od'] * devices['dac']['df'] * devices['fft']['fs'] + devices['out']['of'] * devices['fft']['fd'] * devices['dac']['ds']
print(string.format('%.0f', path_amount))
