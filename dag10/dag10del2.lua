local machines = {}
for line in io.lines('input.txt') do
    local joltage_input = line:sub(line:find('{.+}'))
    local joltage_requirements = {}
    for joltage in string.gmatch(joltage_input, '[^,{}]+') do
        table.insert(joltage_requirements, tonumber(joltage))
    end

    local buttons = {}
    for button_list in string.gmatch(line, "%(([%d,]+)%)") do
        button_list = ','..button_list..','
        local button = ''
        for indicator = 0, #joltage_requirements-1 do
            button = button..(button_list:find(','..indicator..',') and '1' or '0')
        end
        table.insert(buttons, button)
    end

    table.sort(buttons, function (a, b)
        return a:gsub('1', '1') > b:gsub('1', '1')
    end)

    local machine = {joltage_requirements = joltage_requirements, buttons = buttons}
    table.insert(machines, machine)
end

-- print(vim.inspect(machines[1]))

local function check_buttons(machine, sequence, shortest_sequence)
    local done = true
    local sequence_step = sequence[#sequence]
    if shortest_sequence and #sequence >= shortest_sequence then return -1 end
    if sequence_step.next_button > #machine.buttons then return -1 end

    local button = machine.buttons[sequence_step.button_nr]
    sequence_step.output_indicators = {}
    for indicator_nr, joltage_requirement in ipairs(machine.joltage_requirements) do
        sequence_step.output_indicators[indicator_nr] = sequence_step.input_indicators[indicator_nr] + button:sub(indicator_nr,indicator_nr)
        if sequence_step.output_indicators[indicator_nr] > joltage_requirement then return -1 end
        if sequence_step.output_indicators[indicator_nr] < joltage_requirement then
            done = false
        end
    end
    if done then
        print('*')
        return 1
    end
    return 0
end

local total_presses = 0
for t, machine in ipairs(machines) do
    print(t)
    print(#machine.buttons)
    local shortest_sequence
    local button_sequence = {{button_nr = 1, next_button = 1}}
    local joltage_indicators = {}
    for _ = 1, #machine.joltage_requirements do
        table.insert(joltage_indicators, 0)
    end
    button_sequence[1].input_indicators = joltage_indicators

    local timeout = 10000
    while true do
        local status = check_buttons(machine, button_sequence, shortest_sequence)
        for _, button in ipairs(button_sequence) do
            -- print(button.button_nr)
        end
        -- print(vim.inspect(button_sequence[#button_sequence]))
        -- print(status)
        -- print('==========')
        if status == 0 then
            table.insert(button_sequence, {
            button_nr = button_sequence[#button_sequence].next_button,
            next_button = button_sequence[#button_sequence].next_button,
            input_indicators = button_sequence[#button_sequence].output_indicators})
        end
        if status < 0 then
            table.remove(button_sequence)
            if #button_sequence == 0 then break end
            button_sequence[#button_sequence].next_button = button_sequence[#button_sequence].next_button + 1
        end
        if status > 0 then
            shortest_sequence = #button_sequence
        end
        -- if timeout == 0 then break end
        timeout = timeout - 1
    end
    total_presses = total_presses + shortest_sequence
end

print(total_presses)
