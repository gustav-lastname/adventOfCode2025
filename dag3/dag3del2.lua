local input = {}

for line in io.lines('dag3/input.txt') do table.insert(input, line) end

local joltsum = 0

for _, bank in ipairs(input) do
    local bankjolt = ''
    local batteryammount = 12
    local lastbatteryposition = 0
    for battery = 1, batteryammount do
        local currentmaxposition = lastbatteryposition + 1
        for i = currentmaxposition+1, #bank-(batteryammount-battery) do
            if tonumber(bank:sub(i,i)) > tonumber(bank:sub(currentmaxposition,currentmaxposition)) then
                currentmaxposition = i
            end
        end
        lastbatteryposition = currentmaxposition
        bankjolt = bankjolt .. bank:sub(currentmaxposition,currentmaxposition)
    end

    joltsum = joltsum + tonumber(bankjolt)
end
print(string.format('%.f', joltsum))
