package.path = package.path .. ";KolOS/?.lua"

local GUI = {}
GUI.__index = GUI

local Frame = require("components.Frame")

-- GUI class
function GUI:new(frames)
    local obj = setmetatable({}, self)
    obj.frames = {} or frames
    return obj
end

function GUI:addFrame(x, y, width, height, parent, name)
    local frame = Frame:new(x, y, width, height, parent, name)
    table.insert(self.frames, frame)
    return frame
end

-- function GUI:draw()
--     for _, frame in ipairs(self.frames) do
--         frame:draw()
--         frame.win.redraw()
--     end
-- end

-- function GUI:handleClick(x, y)
--     for _, frame in ipairs(self.frames) do
--         frame:handleClick(x, y)
--     end
-- end

-- function GUI:handleKey(key)
--     for _, frame in ipairs(self.frames) do
--         frame:handleKey(key)
--     end
-- end

function GUI:update(event, param1, param2, param3)
    for _, frame in ipairs(self.frames) do
        frame:update(event, param1, param2, param3)
    end
end

function GUI:run(...)
    parallel.waitForAny(
        function ()
            while true do
                local event, param1, param2, param3 = os.pullEvent()
                self:update(event, param1, param2, param3)
            end
        end
    )
end

return GUI:new()
