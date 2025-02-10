local kolos = require("KolOS")

local frame = kolos:addFrame()

local bg = frame:addRect(1, 1, 51, 19, colors.black, true, " ", colors.black)

for i = 0, 255 do
    local rift = 0
    local iRift = i + rift
    if iRift > 255 then
        break
    end
    local str = string.char(iRift)
    local num = string.format("%x", iRift)
    local x = i % 20 * 4 + 2
    local y = 2 + math.floor(i / 20) * 2
    frame:addLabel(x, y, str, colors.white, colors.gray)
    frame:addLabel(x + 1, y, num, colors.white, colors.black)
end

for i = 1, 50, 2 do
    frame:addLine(1, i, 200, i, colors.lightGray, 'alpha', '\x0f')
end

kolos:run()