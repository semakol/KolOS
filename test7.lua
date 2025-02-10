local kolos = require("KolOS")

local frame = kolos:addFrame()

local line = frame:addLine()
    :setColors(colors.green)

local sost = {
    {x1 = 20, y1 = 5, x2 = 30, y2 = 15, char = '\\'},
    {x1 = 20, y1 = 10, x2 = 30, y2 = 10, char = '-'},
    {x1 = 20, y1 = 15, x2 = 30, y2 = 5, char = '/'},
    {x1 = 25, y1 = 5, x2 = 25, y2 = 15, char = '|'},
}

local i = 1

while true do
    line:setParams(sost[i % 4 + 1])
    sleep(0.2)
    line:setColors(colors.fromBlit(string.format("%x", (i % 15))))
    i = i + 1
end