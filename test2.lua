local kolos = require("KolOS")

local gui = kolos:new()

local label = gui:addLabel()
    :setPosition(2, 2)
    :setText("Hello, World!")
    :setColors(colors.white)

local input = gui:addInput()
    :setPosition(2, 6)
    :setSize(20, 100)
    :setColors(colors.gray, colors.white)

local textarea = gui:addTextarea()
    :setPosition(2, 8)
    :setSize(20, 5)
    :setColors(colors.gray, colors.white)

local rect = gui:addRect()
    :setPosition(30, 5)
    :setSize(10, 5)
    :setColors(colors.blue)
    :setFill(true)

local button = gui:addButton()
    :setPosition(2, 4)
    :setLabel("Click Me")
    :addCallback(function()
        textarea:addLine("> "..input.text)
    end)

local dropdown = gui:addDropdown()
    :setPosition(2, 14)
    :setSize(20)
    :setItems({"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7"})
    :setColors(colors.gray, colors.white)

local switch = gui:addSwitch()
    :setPosition(2, 16)
    :setState(false)
    :setCallback(function(state)
        label:setText("Switch state: " .. tostring(state))
    end)
    :setTexts("ON", "OFF")
    :setColors(colors.green, colors.red, colors.white, colors.white)

local line = gui:addLine()
    :setCoordinates(29, 4, 40, 10)
    :setColors(colors.yellow, colors.black)
    :setChar("V")

local circle = gui:addCircle()
    :setPosition(31, 6, 38, 8)
    :setColors(colors.red)
    :setFill(true)

parallel.waitForAny(
    function()
        while true do
            local event, param1, param2, param3 = os.pullEvent()
            l = {}
            for index, value in ipairs({event, param1, param2, param3}) do
                table.insert(l, tostring(value))
            end
            -- textarea:addLine(table.concat(l, ' '))
            gui:update(event, param1, param2, param3)
        end
    end)
