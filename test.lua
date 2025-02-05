local GUI2 = require("KolOS")

print(package.path)

local function main()
    local gui = GUI2:new(1, 1, 51, 19)

    -- Add a textarea
    local textarea = gui:addTextarea(2, 10, 30, 3)
    textarea:setText("This is a      textarea.\nYou, can.. --type multiple lines here.")

    -- Add a label
    local label = gui:addLabel(2, 2, "Label Hello, World!")

    -- Add a button
    gui:addButton(2, 6, "Click Me", {function()
        textarea:setSize(textarea.width + 1, textarea.height + 1)
    end})

    -- Add an input field
    -- local input = gui:addInput(2, 6, 20)
    -- input.text = "Type here"

    local input2 = gui:addInput(2, 8, 20)
    input2.text = "Type here"

    local rect = gui:addRect(35, 2, 15, 10, colors.red, true, "-", colors.yellow)
    local circle = gui:addCircle(36, 3, 48, 10, colors.white, true, " ", colors.yellow)

    -- Add a dropdown
    local dropdown = gui:addDropdown(2, 4, 20, {"Optionssssssssssssssssssssssssss 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"})

    -- Add a switch
    local switch = gui:addSwitch(2, 14, false, function(state)
        if state then
            label:setText("Switch is ON")
        else
            label:setText("Switch is OFF")
        end
    end)

    -- Add a line
    local line = gui:addLine(2, 16, 20, 18, colors.yellow, colors.black, "=")

    -- Add a key handler
    local keyHandler = gui:addKeyHandler()
    keyHandler:registerKey(keys.q, function()
        textarea:setSize(textarea.width - 1, textarea.height - 1)
    end)

    -- Run the GUI
    local ok, error = pcall(function ()
        while true do
            local event, param1, param2, param3 = os.pullEvent()
            l = {}
            for index, value in ipairs({event, param1, param2, param3}) do
                table.insert(l, tostring(value))
            end
            textarea:addLine(table.concat(l, ' '))
            gui:update(event, param1, param2, param3)
        end
    end)
    term.clear()
    if not ok then
        printError(error)
    end
end

main()
