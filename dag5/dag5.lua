local input = {}
local seperator_line

for line in io.lines('input.txt') do
    table.insert(input, line)
    if line == '' then
        seperator_line = #input
    end
end

local ranges = {}
local ingredients = {}

for i = 1, seperator_line-1 do
    local seperator = string.find(input[i], '-')
    local start = tonumber(input[i]:sub(1,seperator-1))
    local stop = tonumber(input[i]:sub(seperator+1))
    table.insert(ranges, {start, stop})
end

for i = seperator_line+1, #input do
    table.insert(ingredients, tonumber(input[i]))
end

local function is_fresh(ingredient)
    for i = 1, #ranges do
        local range = ranges[i]
        if ingredient >= range[1] and ingredient <= range[2] then return true end
    end
    return false
end
local fresh_ingredient_amount = 0

for _, ingredient in ipairs(ingredients) do
    if is_fresh(ingredient) then
        fresh_ingredient_amount = fresh_ingredient_amount + 1
    end
end

print(fresh_ingredient_amount)
