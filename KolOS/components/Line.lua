local Line = {}
Line.__index = Line

function Line:new(x1, y1, x2, y2, color, bgColor, char)
    local obj = setmetatable({}, self)
    obj.x1 = x1 or 0
    obj.y1 = y1 or 0
    obj.x2 = x2 or 0
    obj.y2 = y2 or 0
    obj.color = color or colors.white
    obj.bgColor = bgColor or colors.black
    obj.char = char or "-"
    return obj
end

function Line:setCoordinates(x1, y1, x2, y2)
    self.x1 = x1 or self.x1
    self.y1 = y1 or self.y1
    self.x2 = x2 or self.x2
    self.y2 = y2 or self.y2
    return self
end

function Line:setColors(color, bgColor)
    self.color = color
    self.bgColor = bgColor
    return self
end

function Line:setChar(char)
    self.char = char
    return self
end

function Line:draw(canvas)
    if self.y1 == self.y2 then
        for x = self.x1, self.x2 do
            if canvas[self.y1] and canvas[self.y1][x] then
                canvas[self.y1][x].bgColor = self.bgColor
                canvas[self.y1][x].char = self.char
                canvas[self.y1][x].charColor = self.color
            end
        end
    elseif self.x1 == self.x2 then
        for y = self.y1, self.y2 do
            if canvas[y] and canvas[y][self.x1] then
                canvas[y][self.x1].bgColor = self.bgColor
                canvas[y][self.x1].char = self.char
                canvas[y][self.x1].charColor = self.color
            end
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
            if canvas[y] and canvas[y][x] then
                canvas[y][x].bgColor = self.bgColor
                canvas[y][x].char = self.char
                canvas[y][x].charColor = self.color
            end

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
