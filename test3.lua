local GUI = require("KolOS")

local gui = GUI:new()

local inputParams = {
    x = 2,
    y = 3,
    width = 20,
    maxLength = 50,
    bgColor = colors.gray,
    textColor = colors.white,
    -- replaceChar = "*",
    history = {"example1", "example2"},
    completeFn = function(text)
        return {"completion1", "completion2"}
    end,
    default = "default text",
    callback = function(text)
        print("Input submitted: " .. text)
    end,
    deactivateOnEnter = true
}

local input = gui:addInput(inputParams)

gui:run()
