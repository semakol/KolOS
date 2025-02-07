

local kolos = require("KolOS")

local monitor = peripheral.wrap("left")

local frame = kolos:addFrame()

local frame2 = kolos:addFrame(1, 1, nil, nil, monitor, "left")

frame2:addLabel(1, 1, "Hello, world!", colors.red)

local textarea = frame:addTextarea(2, 2, 30, 10)

local button = frame2:addButton(2, 3, "Click Me", {function()
    textarea:addLine("Button clicked!")
end})

while true do
    local event, param1, param2, param3 = os.pullEvent()
    l = {}
    for index, value in ipairs({event, param1, param2, param3}) do
        table.insert(l, tostring(value))
    end
    textarea:addLine(table.concat(l, ' '))
    kolos:update(event, param1, param2, param3)
end