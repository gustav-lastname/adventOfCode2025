local input = {}

for line in io.lines('input.txt') do table.insert(input, line) end

local joltsum = 0

for _, bank in ipairs(input) do
    local firstposition = 1
    local firstvalue = tonumber(bank:sub(1,1))
    for i = 2, #bank-1 do
        if tonumber(bank:sub(i,i)) > firstvalue then
            firstposition = i
            firstvalue = tonumber(bank:sub(i,i))
        end
    end

    local secondposition = firstposition + 1
    local secondvalue = tonumber(bank:sub(secondposition,secondposition))
    for i = secondposition + 1, #bank do
        if tonumber(bank:sub(i,i)) > secondvalue then
            secondposition = i
            secondvalue = tonumber(bank:sub(i,i))
        end
    end

    local bankjolt = firstvalue..secondvalue
    joltsum = joltsum + bankjolt
end
print(joltsum)
