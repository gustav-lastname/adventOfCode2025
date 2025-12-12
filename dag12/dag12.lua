local presents = {}
local regions = {}

local parts = {{}}
for line in io.lines('input.txt') do
    if line ~= '' then
        table.insert(parts[#parts], line)
    else
        table.insert(parts, {})
    end
end

local function rotate_present(present)
    local output = {}
    for y = 1, 3 do
        local row = ''
        for x = 3, 1, -1 do
            row = row..present[x]:sub(y,y)
        end
        table.insert(output, row)
    end
    return output
end

local function flip_present(present)
    local output = {}
    for y = 1, 3 do
        local row = ''
        for x = 3, 1, -1 do
            row = row..present[y]:sub(x,x)
        end
        table.insert(output, row)
    end
    return output
end

local function add_version(version, version_list)
    for _, item in ipairs(version_list) do
        local unique = false
        for row = 1, #version do
            if version[row] ~= item[row] then unique = true end
            end
        if not unique then return end
    end
    table.insert(version_list, version)
end

for part_nr, part in ipairs(parts) do
    if part_nr < #parts then
        local present = {}
        for row_nr = 2, #part do
            table.insert(present, part[row_nr])
        end

        local present_versions = {}
        add_version(present, present_versions)

        for _ = 1, 3 do
            present = rotate_present(present)
            add_version(present, present_versions)
        end
        present = flip_present(present)
        add_version(present, present_versions)
        for _ = 1, 3 do
            present = rotate_present(present)
            add_version(present, present_versions)
        end

        table.insert(presents, present_versions)
    else
        for _, row in ipairs(part) do
            local dimensions = {}
            for dimension in string.gmatch(row:sub(string.find(row, '[%dx]+%:')), '%d+') do
                table.insert(dimensions, tonumber(dimension))
            end

            local region_presents = {}
            local present_type = 1
            for present_amount in string.gmatch(row:sub(string.find(row, '%:[%d%s]+')), '%d+') do
                for _ = 1, present_amount do
                    table.insert(region_presents, present_type)
                end
                present_type = present_type + 1
            end

            table.insert(regions, {dimensions = dimensions, present_sequence = region_presents})
        end
    end
end

-- print(vim.inspect(presents))
-- print(vim.inspect(regions))

local function place_present(step, region)
    if not step.past then
        local present = presents[region.present_sequence[step.present_nr]][step.version]
        print(vim.inspect(step))
        for _, row in ipairs(present) do
            print(row)
        end

        step.outfield = {}
        for y_nr, y in ipairs(step.infield) do
            local row = ''
            for x_nr = 1, #y do
                local x = y:sub(x_nr,x_nr)
                if present[1+y_nr-step.coordinates[2]] then
                    if present[1+y_nr-step.coordinates[2]]:sub(1+x_nr-step.coordinates[1], 1+x_nr-step.coordinates[1]) ~= '' then
                        print(1+x_nr-step.coordinates[1])
                        print(x_nr, y_nr)
                        if x == '.' or present[1+y_nr-step.coordinates[2]]:sub(1+x_nr-step.coordinates[1], 1+x_nr-step.coordinates[1]) == '.' then
                            if x == '.' then
                                x = present[1+y_nr-step.coordinates[2]]:sub(1+x_nr-step.coordinates[1], 1+x_nr-step.coordinates[1])
                            end
                        else
                            goto increment
                        end
                    end
                end
                row = row..x
            end
            table.insert(step.outfield, row)
        end
        step.past = true
        print('=====')
        for _, row in ipairs(step.outfield) do
            print(row)
        end
        return 1
    end

    ::increment::
    step.past = false

    step.version = step.version + 1
    if tonumber(step.version) > #presents[region.present_sequence[step.present_nr]] then
        step.version = 1
        step.coordinates[1] = step.coordinates[1] + 1
    end
    if step.coordinates[1] + 2  > region.dimensions[1] then
        print('ajdå')
        step.coordinates[1] = 1
        step.coordinates[2] = step.coordinates[2] + 1
    end
    if step.coordinates[2] + 2  > region.dimensions[2] then
        print('naj')
        return -1
    end
    return 0
end

local possible_trees = 0
for _, region in ipairs(regions) do
    local placement_sequence = {{present_nr = 1, coordinates = {1, 1}, version = 1}}
    local infield = {}
    for _ = 1, region.dimensions[2] do
        table.insert(infield, '')
        for _ = 1, region.dimensions[1] do
            infield[#infield] = infield[#infield]..'.'
        end
    end
    placement_sequence[1].infield = infield

    local timeout = 10000000
    while true do
        local step = placement_sequence[#placement_sequence]
        local status = place_present(step, region)
        -- print(vim.inspect(placement_sequence))
        -- print(vim.inspect(presents[region.present_sequence[step.present_nr]]))
        if status < 0 then
            table.remove(placement_sequence)
            break
        end
        if status > 0 then
            print(vim.inspect(placement_sequence))
            if step.present_nr + 1 > #region.present_sequence then
                possible_trees = possible_trees + 1
                break
            end
            local new_step ={coordinates = {1,1}, version = 1}
            new_step.present_nr = step.present_nr + 1
            new_step.infield = step.outfield
            table.insert(placement_sequence, new_step)
        end
        -- step.version = 1
        -- step.coordinates[1] = 1
        -- step.coordinates[2] = step.coordinates[2] + 1
        if timeout == 0 then break end
        timeout = timeout - 1
    end
end

print(possible_trees)
