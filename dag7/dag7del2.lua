
local input = {}
for line in io.lines('input.txt') do
    table.insert(input, line)
end

local beams = {}
for character_nr = 1, #input[1] do
    if input[1]:sub(character_nr, character_nr) == 'S' then
        table.insert(beams, {position = character_nr, amount = 1})
    end
end

local new_beams = {}

local function add_beam(beam, offset)
    for beam_nr = 1, #new_beams do
        if new_beams[beam_nr].position == beam.position+offset then
            new_beams[beam_nr].amount = new_beams[beam_nr].amount + beam.amount
            return
        end
    end
    table.insert(new_beams, {position = beam.position + offset, amount = beam.amount})
end

for line_nr = 2, #input do
    local line = input[line_nr]
    for beam_nr = 1, #beams do
        local beam = beams[beam_nr]
        if line:sub(beam.position, beam.position) == '^' then
            add_beam(beam, -1)
            add_beam(beam, 1)
        else
            add_beam(beam, 0)
        end
    end

    beams = new_beams
    new_beams = {}
end

local paths = 0

for beam_nr = 1, #beams do
    paths = paths + beams[beam_nr].amount
end

print(paths)
