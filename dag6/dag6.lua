local base_input = {}
for line in io.lines('input.txt') do
    local formatted_line = {}
    for part in string.gmatch(line, '([^ ]+)') do
        table.insert(formatted_line, part)
    end
    table.insert(base_input, formatted_line)
end

local input = {}
for i = 1, #base_input[1] do
    local problem = {}
    for j = 1, #base_input do
        table.insert(problem, base_input[j][i])
    end
    table.insert(input, problem)
end

local total_sum = 0

for problem_nr = 1, #input do
    local problem = input[problem_nr]
    local problem_result = 0
    if problem[#problem] == '*' then
        problem_result = 1
        for i = 1, #problem-1 do
            problem_result = problem_result * tonumber(problem[i])
        end
    elseif problem[#problem] == '+' then
        for i = 1, #problem-1 do
            problem_result = problem_result + tonumber(problem[i])
        end
    end
    total_sum = total_sum + problem_result
end

print(total_sum)
