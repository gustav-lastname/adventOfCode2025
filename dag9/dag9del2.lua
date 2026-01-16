local tiles = {}
for line in io.lines('input.txt') do
    local tile = {}
    for coordinate in string.gmatch(line, '[^,]+') do
        table.insert(tile, tonumber(coordinate))
    end
    table.insert(tiles, tile)
end

local largest_area = 0

for tile1_nr, tile1 in ipairs(tiles) do
    for tile2_nr = 1, tile1_nr-1 do
        local tile2 = tiles[tile2_nr]
        local area = (math.abs(tile1[1]-tile2[1])+1) * (math.abs(tile1[2]-tile2[2])+1)
        largest_area = area > largest_area and area or largest_area
    end
end

print(largest_area)
