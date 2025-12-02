local input = '17330-35281,9967849351-9967954114,880610-895941,942-1466,117855-209809,9427633930-9427769294,1-14,311209-533855,53851-100089,104-215,33317911-33385573,42384572-42481566,43-81,87864705-87898981,258952-303177,451399530-451565394,6464564339-6464748782,1493-2439,9941196-10054232,2994-8275,6275169-6423883,20-41,384-896,2525238272-2525279908,8884-16221,968909030-969019005,686256-831649,942986-986697,1437387916-1437426347,8897636-9031809,16048379-16225280'
-- input = '11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124'

local function splitstring(inputString, sep)
    local t={}
    for str in string.gmatch(inputString, '([^'..sep..']+)')do
        table.insert(t, str)
    end
    return t
end

local idSum = 0
local inputtable = splitstring(input, ",")

for _, range in ipairs(inputtable) do
    for id=tonumber(splitstring(range, '-')[1]), tonumber(splitstring(range, '-')[2]) do
        local stringid = tostring(id)
        local sequenceLength = 1
        local invalid = false
        while (not invalid) and sequenceLength <= #stringid/2 do
            if #stringid%sequenceLength == 0 then
                local unsure = true
                local i = 2
                local comparestring = stringid:sub(1,sequenceLength)
                while unsure and i*sequenceLength <= #stringid do
                    if comparestring ~= stringid:sub((i-1)*sequenceLength+1,i*sequenceLength) then
                        unsure = false
                    end
                    i = i + 1
                end
                invalid = unsure
            end
            sequenceLength = sequenceLength + 1
        end
        if invalid then
            idSum = idSum + id
        end
    end
end

print(idSum)
