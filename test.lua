local GUI = require("KolOS")

local function main()
    local i = 1
    local gui = GUI:new(1, 1, 51, 19)

    -- Add a textarea
    local textarea = gui:addTextarea(2, 10, 30, 5)
    textarea:setText("This is a textarea.\nYou can type multiple lines here.")

    -- Add a label
    local label = gui:addLabel(2, 2, "Label: Hello, World!")

    -- Add a button
    gui:addButton(2, 4, "Click Me", function()
        textarea:setSize(textarea.width + 1, textarea.height + 1)
    end)

    -- Add an input field
    local input = gui:addInput(2, 6, 20)
    input.text = "Type here"

    local input2 = gui:addInput(2, 8, 20)
    input2.text = "Type here"

    local rect = gui:addRect(35, 2, 15, 10, colors.red)

    -- Add a key handler
    local keyHandler = gui:addKeyHandler()
    keyHandler:registerKey(keys.q, function()
        textarea:setSize(textarea.width - 1, textarea.height - 1)
    end)

    -- Run the GUI
    gui:run()
end

main()
