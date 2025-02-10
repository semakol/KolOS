local gui = require("KolOS")
local frame = gui:addFrame()

local function main()
    -- Add a textarea
    local textarea = frame:addTextarea(2, 10, 30, 3)
    textarea:setText("This is a      textarea.\nYou, can.. --type multiple lines here.")

    -- Add a label
    local label = frame:addLabel(2, 2, "Label Hello, World!")

    -- Add a button
    frame:addButton(2, 6, "Click Me", {function()
        textarea:setSize(textarea.width + 1, textarea.height + 1)
    end})

    -- Add an input field
    -- local input = frame:addInput(2, 6, 20)
    -- input.text = "Type here"

    local input2 = frame:addInput(2, 8, 20)
    input2.text = "Type here"

    local rect = frame:addRect(35, 2, 15, 10, colors.red, true, "-", colors.yellow)
    local circle = frame:addCircle(36, 3, 48, 10, colors.white, true, " ", colors.yellow)

    -- Add a dropdown
    local dropdown = frame:addDropdown(2, 4, 20, {"Optionssssssssssssssssssssssssss 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"})

    -- Add a switch
    local switch = frame:addSwitch(2, 14, false, function(state)
        if state then
            label:setText("Switch is ON")
        else
            label:setText("Switch is OFF")
        end
    end)

    -- Add a line
    local line = frame:addLine(2, 16, 20, 18, colors.yellow, colors.black, "|")

    -- Add a key handler
    local keyHandler = frame:addKeyHandler()
    keyHandler:registerKey(keys.q, function()
        textarea:setSize(textarea.width - 1, textarea.height - 1)
    end)

    -- Run the frame
    local ok, error = pcall(function ()
        while true do
            local event, param1, param2, param3 = os.pullEvent()
            l = {}
            for index, value in ipairs({event, param1, param2, param3}) do
                table.insert(l, tostring(value))
            end
            textarea:addLine(table.concat(l, ' '))
            frame:update(event, param1, param2, param3)
        end
    end)
    term.clear()
    if not ok then
        printError(error)
    end
end

main()
