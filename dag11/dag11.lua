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

local path = {{device = 'out', direction = 1}}
while true do
    local step = path[#path]
    if devices[step.device].connections[step.direction] == nil then
        table.remove(path)
        if #path == 0 then break end
        path[#path].direction = path[#path].direction + 1
        devices[path[#path].device].paths = (devices[path[#path].device].paths or 0) + (devices[step.device].paths or 0)
    elseif devices[step.device].connections[step.direction] == 'you' then
        devices[step.device].paths = 1
        table.remove(path)
        path[#path].direction = path[#path].direction + 1
        devices[path[#path].device].paths = (devices[path[#path].device].paths or 0) + devices[step.device].paths
    else
        local next = devices[devices[step.device].connections[step.direction]]
        if next.paths then
            devices[step.device].paths = (devices[step.device].paths or 0) + next.paths
            step.direction = step.direction + 1
        else
            table.insert(path, {device = devices[step.device].connections[step.direction], direction = 1})
        end
    end
end

print(devices['out'].paths)
