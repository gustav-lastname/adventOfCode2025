local input = {}

local available_paper = 0

for line in io.lines('input.txt') do
    table.insert(input, line)
end

local function ispaper(row_nr, col_nr)
    if input[row_nr] == nil then return false end
    if col_nr < 1 or row_nr < 1 or col_nr > #input[row_nr] then
        return false
    end
    if input[row_nr]:sub(col_nr,col_nr) == '@' then
        return true
    else
        return false
    end
end

local function replace_chr(s,at,with)
    return s:sub(1,at-1)..with..s:sub(at+1)
end

local done = false
local new_input = input

while not done do
    local removed_paper = 0

    for row_nr, row in ipairs(input) do
        for col_nr = 1, #row do
            if ispaper(row_nr,col_nr) then
                local adjacent_paper = 0
                for col_ofset = -1,1 do
                    for row_ofset = -1,1 do
                        adjacent_paper = adjacent_paper + (ispaper(row_nr + row_ofset, col_nr + col_ofset) and 1 or 0)
                    end
                end
                if adjacent_paper < 5 then
                    removed_paper = removed_paper + 1
                    new_input[row_nr] = replace_chr(new_input[row_nr],col_nr,'x')
                end
            end
        end
    end
    input = new_input
    available_paper = available_paper + removed_paper

    if removed_paper == 0 then
        done = true
    end
end


print(available_paper)
