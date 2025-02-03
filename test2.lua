local kolos = require("KolOS")

local gui = kolos:new()

local label = gui:addLabel(10, 5, "Hello, World!", colors.white)

local input = gui:addInput(5, 7, 20, 100, colors.gray, colors.white)

local textarea = gui:addTextarea(5, 9, 20, 5, colors.gray, colors.white)

local rect = gui:addRect(30, 5, 10, 5, colors.blue, true)

local button = gui:addButton(5, 5, "Click Me", {function()
    textarea:addLine("Button clicked!")
end})

local dropdown = gui:addDropdown(5, 15, 20, {"Option 1", "Option 2", "Option 3"}, colors.gray, colors.white)

local switch = gui:addSwitch(5, 20, false, function(state)
    print("Switch state: " .. tostring(state))
end, "ON", "OFF", colors.green, colors.red, colors.white, colors.white)

local line = gui:addLine(30, 15, 40, 15, colors.yellow)

local circle = gui:addCircle(30, 20, 35, 25, colors.red, true)

while true do
    local event, param1, param2, param3 = os.pullEvent()
    l = {}
    for index, value in ipairs({event, param1, param2, param3}) do
        table.insert(l, tostring(value))
    end
    textarea:addLine(table.concat(l, ' '))
    gui:update(event, param1, param2, param3)
end