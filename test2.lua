local kolos = require("KolOS")
local completion = require "cc.completion"

local frame = kolos:addFrame()

local bg = frame:addRect()
    :setPosition(1, 1)
    :setSize(90, 20)
    :setColors(colors.black)
    :setFill(true)

local label = frame:addLabel()
    :setPosition(2, 2)
    :setText("Hello, World!")
    :setColors(colors.white, 'alpha')

local textarea = frame:addTextarea()
    :setPosition(2, 8)
    :setSize(20, 5)
    :setColors(colors.gray, colors.white)
    -- :setZIndex(100)

local input = frame:addInput()
    :setPosition(2, 6)
    :setSize(20, 100)
    :setColors(colors.gray, colors.white)
    -- :setReplaceChar('l')
    :setHistory({'scam', 'aboba'})
    :setCompleteFn(function(text)
        return completion.choice(text, {"scam", "aboba", "abbba", "ababa", "abiba", "aboba", "abuba"})
    end)
    :setCallback(function(text)
        textarea:addLine("> " .. text)
    end)
    :setDeactivateOnEnter(false)

local rect = frame:addRect()
    :setPosition(30, 5)
    :setSize(10, 5)
    :setColors("alpha", colors.blue)
    :setFill(true)
    :setChar("\x7f")

local button = frame:addButton()
    :setPosition(2, 4)
    :setLabel("Click Me")
    :addCallback(function()
        textarea:addLine("> "..input.text)
    end)

local dropdown = frame:addDropdown()
    :setPosition(2, 14)
    :setSize(20)
    :setItems({"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7"})
    :setColors(colors.gray, colors.white)
    :setZIndex(100)

local switch = frame:addSwitch()
    :setPosition(2, 16)
    :setState(false)
    :setCallback(function(state)
        label:setText("Switch state: " .. tostring(state))
    end)
    :setTexts("ON", "OFF")
    :setColors(colors.green, colors.red, colors.white, colors.white)

local line = frame:addLine()
    :setCoordinates(30, 4, 39, 10)
    :setColors(colors.white, "alpha")
    :setChar("\\")

local line2 = frame:addLine()
    :setCoordinates(30, 10, 39, 4)
    :setColors(colors.white, "alpha")
    :setChar("/")

local circle = frame:addCircle()
    :setPosition(31, 6, 38, 8)
    :setColors(colors.red)
    :setFill(true)

local image = frame:addImage()
    :setPosition(41, 4)
    :loadFile("img_test")
    :setZIndex(100)

local ok, error = pcall(function ()
    parallel.waitForAny(
        function()
            while true do
                local event, param1, param2, param3 = os.pullEvent()
                l = {}
                for index, value in ipairs({event, param1, param2, param3}) do
                    table.insert(l, tostring(value))
                end
                -- textarea:addLine(table.concat(l, ' '))
                kolos:update(event, param1, param2, param3)
            end
        end)
end)

term.clear()
term.setCursorPos(1,1)
if not ok then
    printError(error)
end
