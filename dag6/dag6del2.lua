local input = {}
for line in io.lines('input.txt') do
    table.insert(input, line)
end

local input_width = #input[1]

local problems = {}
local problem = {}

local skip_next = false

for i=0, input_width-1 do
    if skip_next then
        skip_next = false
    else
        local line = ''
        for j=1, #input do
            local character = input[j]:sub(input_width-i,input_width-i)
            if character == '*' or character == '+' then
                table.insert(problem, line)
                table.insert(problem, character)
                table.insert(problems, problem)
                problem = {}
                skip_next = true
            else
                line = line..character
            end
        end
        if not skip_next then table.insert(problem, line) end
    end
end

local total_sum = 0

for problem_nr = 1, #problems do
    local problem_input = problems[problem_nr]
    local problem_result = 0
    if problem_input[#problem_input] == '*' then
        problem_result = 1
        for factor_nr = 1, #problem_input-1 do
            local factor = problem_input[factor_nr]
            problem_result = problem_result * tonumber(factor)
        end
    else
        for term_nr = 1, #problem_input-1 do
            local term = problem_input[term_nr]
            problem_result = problem_result + tonumber(term)
        end
    end
    total_sum = total_sum + problem_result
end

print(total_sum)
