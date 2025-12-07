local input = {}
for line in io.lines('input.txt') do
    table.insert(input, line)
end

local beams = {}
for character_nr = 1, #input[1] do
    if input[1]:sub(character_nr, character_nr) == 'S' then
        table.insert(beams, character_nr)
    end
end

local new_beams = {}

local function is_added(beam)
    for beam_nr = 1, #new_beams do
        if new_beams[beam_nr] == beam then
            return true
        end
    end
    return false
end

local splits = 0

for line_nr = 2, #input do
    local line = input[line_nr]
    for beam_nr = 1, #beams do
        local beam = beams[beam_nr]
        if line:sub(beam, beam) == '^' then
            if not is_added(beam-1) then
                table.insert(new_beams, beam-1)
            end
            if not is_added(beam+1) then
                table.insert(new_beams, beam+1)
            end
            splits = splits + 1
        else
            if not is_added(beam) then
                table.insert(new_beams, beam)
            end
        end
    end

    beams = new_beams
    new_beams = {}
end

print(splits)
