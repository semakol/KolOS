local Line = {}
Line.__index = Line

function Line:new(x1, y1, x2, y2, color, bgColor, char)
    local obj = setmetatable({}, self)
    obj.x1 = x1
    obj.y1 = y1
    obj.x2 = x2
    obj.y2 = y2
    obj.color = color or colors.white
    obj.bgColor = bgColor or colors.black
    obj.char = char or "-"
    return obj
end

function Line:draw(win)
    win.setTextColor(self.color)
    win.setBackgroundColor(self.bgColor)
    if self.y1 == self.y2 then
        win.setCursorPos(self.x1, self.y1)
        win.write(string.rep(self.char, self.x2 - self.x1 + 1))
    elseif self.x1 == self.x2 then
        for y = self.y1, self.y2 do
            win.setCursorPos(self.x1, y)
            win.write(self.char)
        end
    else
        local dx = math.abs(self.x2 - self.x1)
        local dy = math.abs(self.y2 - self.y1)
        local sx = self.x1 < self.x2 and 1 or -1
        local sy = self.y1 < self.y2 and 1 or -1
        local err = dx - dy

        local x = self.x1
        local y = self.y1

        while true do
            win.setCursorPos(x, y)
            win.write(self.char)

            if x == self.x2 and y == self.y2 then
                break
            end

            local e2 = 2 * err
            if e2 > -dy then
                err = err - dy
                x = x + sx
            end
            if e2 < dx then
                err = err + dx
                y = y + sy
            end
        end
    end
end

return Line
