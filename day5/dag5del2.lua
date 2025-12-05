local input = {}
local seperator_line

for line in io.lines('input.txt') do
    table.insert(input, line)
    if line == '' then
        seperator_line = #input
    end
end

local ranges = {}

for i = 1, seperator_line-1 do
    local seperator = string.find(input[i], '-')
    local start = tonumber(input[i]:sub(1,seperator-1))
    local stop = tonumber(input[i]:sub(seperator+1))
    table.insert(ranges, {start, stop})
end

local done = false
local new_ranges = {}

local function add_range(range)
    for i = 1, #new_ranges do
        local new_range = new_ranges[i]
        if range[1] >= new_range[1] and range[1] <= new_range[2] and range[2] >= new_range[2] then
            new_ranges[i] = {new_range[1], range[2]}
            return
        end
        if range[2] >= new_range[1] and range[2] <= new_range[2] and range[1] <= new_range[1] then
            new_ranges[i] = {range[1], new_range[2]}
            return
        end
        if range[2] > new_range[2] and range[1] < new_range[1] then
            new_ranges[i] = range
            return
        end
        if range[2] <= new_range[2] and range[1] >= new_range[1] then
            return
        end
    end
    table.insert(new_ranges, range)
end

while not done do
    for i = 1, #ranges do
        local range = ranges[i]
        add_range(range)
    end
    if #new_ranges == #ranges then
        done = true
    end
    ranges = new_ranges
    new_ranges = {}
end

local fresh_ingredient_amount = 0

for i = 1, #ranges do
    local range = ranges[i]
    fresh_ingredient_amount = fresh_ingredient_amount + (range[2]-range[1])+1
end

print(string.format('%.f',fresh_ingredient_amount))
