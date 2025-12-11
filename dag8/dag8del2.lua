local boxes = {}
local circuits = {}

for line in io.lines('input.txt') do
    local coordinates = {}

    for coordinate in line:gmatch('[^,]+') do
        table.insert(coordinates, coordinate)
    end

    local circuit = #circuits + 1
    local box = {coordinates = coordinates, circuit = circuit}
    table.insert(boxes, box)
    table.insert(circuits, {box})
end

local function get_distance(box1, box2)
    local coordinates1 = box1.coordinates
    local coordinates2 = box2.coordinates
    return math.sqrt((coordinates1[1]-coordinates2[1])^2 + (coordinates1[2]-coordinates2[2])^2 + (coordinates1[3]-coordinates2[3])^2)
end

local distances = {}
for box1_nr = 1, #boxes do
    for box2_nr = 1, box1_nr-1 do
        local box1 = boxes[box1_nr]
        local box2 = boxes[box2_nr]
        local distance = get_distance(box1, box2)
        table.insert(distances, {distance = distance, boxes = {box1, box2}})
    end
end

table.sort(distances, function (a, b)
    return a.distance < b.distance
end)

local function connect_boxes(box1, box2)
    local box2_circuit = box2.circuit
    for _, box in ipairs(circuits[box2_circuit]) do
        table.insert(circuits[box1.circuit], box)
        box.circuit = box1.circuit
    end
    circuits[box2_circuit] = {}
end

local connections = 1
local circuit_amount = #circuits
local box1
local box2
while circuit_amount > 1 do
    box1 = distances[connections].boxes[1]
    box2 = distances[connections].boxes[2]
    if box1.circuit ~= box2.circuit then
        connect_boxes(box1, box2)
        circuit_amount = circuit_amount - 1
    end
    connections = connections + 1
end

print(box1.coordinates[1] * box2.coordinates[1])
