local machines = {}
for line in io.lines('input.txt') do
    local joltage_input = line:sub(line:find('{.+}'))
    local joltage_requirements = {}
    for joltage in string.gmatch(joltage_input, '[^,{}]+') do
        table.insert(joltage_requirements, joltage)
    end

    local buttons = {}
    local button_lists = {}
    for button_list in string.gmatch(line, "%(([%d,]+)%)") do
        button_list = ','..button_list..','
        local button = ''
        for indicator = 0, #joltage_requirements-1 do
            button = button..(button_list:find(','..indicator..',') and '1' or '0')
        end
        table.insert(buttons, button)
        -- print(button)
    end

    table.sort(buttons, function (a, b)
        return a:gsub('1', '1') > b:gsub('1', '1')
    end)

    local machine = {joltage_requirements = joltage_requirements, buttons = buttons}
    table.insert(machines, machine)
end

print(unpack(machines[1].buttons))

-- print(vim.inspect(machines))

local function check_buttons(machine, buttons, allowed_presses)
    local done = true
    local presses = 0
    for _, button in ipairs(buttons) do
        presses = presses + button
    end
    if presses > allowed_presses then return -1 end

    for nr, joltage_requirement in ipairs(machine.joltage_requirements) do
        local joltage = 0
        for button_nr, button in ipairs(machine.buttons) do
            joltage = joltage + tonumber(button:sub(nr,nr))*buttons[button_nr]
        end
        if joltage < tonumber(joltage_requirement) then done = false end
        if joltage > tonumber(joltage_requirement) then return -1 end
    end
    return done and presses or 0
end

local total_presses = 0
for t, machine in ipairs(machines) do
    local shortest_combination = math.max(unpack(machine.joltage_requirements))
    local button_presses = {}
    for _ = 1, #machine.buttons do
        table.insert(button_presses, 0)
    end

    local first = false
    local timeout = 10000
    local done = false
    while not done do
        shortest_combination = shortest_combination + 1
        print(shortest_combination)
        local position = 1
        while true do
            button_presses[position] = button_presses[position] + 1
            -- print(vim.inspect(button_presses))
            -- print(shortest_combination)
            -- print(button_presses[1])
            print(unpack(button_presses))
            local status = check_buttons(machine, button_presses, shortest_combination)
            -- print(t..'        '..status)
            -- print('-')
            if status > 0 then
                print(unpack(button_presses))
                print(shortest_combination)
                done = true
                break
            end
            if status < 0 then
                for i = 1, position do
                    button_presses[i] = 0
                end
                position = position + 1
                first = true
                if position > #button_presses then break end
            elseif first then
                position = 1
                first = false
            end
        end
        if timeout == 0 then break end
        timeout = timeout - 1
    end
    total_presses = total_presses + shortest_combination

    -- local combinations = to_combinations(combination_amount)
    --
    -- local shortest_combination
    -- for _, combination in ipairs(combinations) do
    --     local result = machine.indicators
    --     for _, button in ipairs(combination) do
    --         result = xor(result, machine.buttons[button])
    --     end
    --     if tonumber(result) == 0 then
    --         shortest_combination = #combination
    --         break
    --     end
    -- end
    -- total_presses = total_presses + shortest_combination
end

print(total_presses)
