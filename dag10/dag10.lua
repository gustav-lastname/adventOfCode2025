local machines = {}
for line in io.lines('input.txt') do
    local indicators = line:sub(line:find('[%.%#]+'))
    local new_indicators = ''
    for character_nr = 1, #indicators do
        local character = indicators:sub(character_nr,character_nr)
        new_indicators = new_indicators..(character == '#' and '1' or '0')
    end
    indicators = new_indicators

    local buttons = {}
    for button_list in string.gmatch(line, "%(([%d,]+)%)") do
        button_list = ','..button_list..','
        local button = ''
        for indicator = 0, #indicators-1 do
            button = button..(button_list:find(','..indicator..',') and '1' or '0')
        end
        table.insert(buttons, button)
    end

    local machine = {indicators = indicators, buttons = buttons}
    table.insert(machines, machine)
end

local function xor(a, b)
    local result = ''
    for i = 1, #a do
        result = result..((a:sub(i,i)+b:sub(i,i))%2==1 and '1' or '0')
    end
    return result
end

local function to_combination(iteration)
    local output = {}
    local i = 1
    while iteration>0 do
        if iteration%2 == 1 then table.insert(output, i) end
        iteration = math.floor(iteration/2)
        i = i + 1
    end
    return output
end

local function to_combinations(iteration)
    local output = {}
    for i = 1, iteration do
        table.insert(output, to_combination(i))
    end

    table.sort(output, function (a, b)
        return #a < #b
    end)

    return output
end

local function pick(a, b)
    local result = 1
    for i = b-a+1, b do
        result = result * i
    end
    for i = 1, a do
        result = result / i
    end
    return result
end

local total_presses = 0
for _, machine in ipairs(machines) do
    local combination_amount = 0
    for i = 1, #machine.buttons do
        combination_amount = combination_amount + pick(i, #machine.buttons)
    end
    local combinations = to_combinations(combination_amount)

    local shortest_combination
    for _, combination in ipairs(combinations) do
        local result = machine.indicators
        for _, button in ipairs(combination) do
            result = xor(result, machine.buttons[button])
        end
        if tonumber(result) == 0 then
            shortest_combination = #combination
            break
        end
    end
    total_presses = total_presses + shortest_combination
end

print(total_presses)
