local Circle = {}
Circle.__index = Circle

function Circle:new(x1, y1, x2, y2, color, fill, char, charColor)
    if type(x1) == "table" then
        local params = x1
        x1 = params.x1
        y1 = params.y1
        x2 = params.x2
        y2 = params.y2
        color = params.color
        fill = params.fill
        char = params.char
        charColor = params.charColor
    end
    local obj = setmetatable({}, self)
    obj.x1 = x1 or 0
    obj.y1 = y1 or 0
    obj.x2 = x2 or 5
    obj.y2 = y2 or 5
    obj.color = color or colors.white
    obj.fill = fill or false
    obj.char = char or " "
    obj.charColor = charColor or colors.white
    obj.pixels = {}
    obj:update()
    return obj
end

function Circle:setPosition(x1, y1, x2, y2)
    self.x1 = x1 or self.x1
    self.y1 = y1 or self.y1
    self.x2 = x2 or self.x2
    self.y2 = y2 or self.y2
    self:update()
    return self
end

function Circle:setColors(color, charColor)
    self.color = color or self.color
    self.charColor = charColor or self.charColor
    return self
end

function Circle:setFill(fill)
    self.fill = fill or self.fill
    self:update()
    return self
end

function Circle:setChar(char)
    self.char = char or self.char
    return self
end

function Circle:update()
    local centerX = (self.x1 + self.x2) / 2
    local centerY = (self.y1 + self.y2) / 2
    local radiusX = math.abs(self.x2 - self.x1) / 2
    local radiusY = math.abs(self.y2 - self.y1) / 2
    local circumference = 2 * math.pi * math.min(radiusX, radiusY)
    local step = 1 / circumference
    self.pixels = {}
    for theta = 0, math.pi / 2, step do
        local x = centerX + radiusX * math.cos(theta)
        local y = centerY + radiusY * math.sin(theta)
        table.insert(self.pixels, {math.floor(x + 0.5), math.floor(y + 0.5)})
    end
    local quarterPixels = {}
    for _, pixel in ipairs(self.pixels) do
        table.insert(quarterPixels, {2 * centerX - pixel[1], pixel[2]})
        table.insert(quarterPixels, {pixel[1], 2 * centerY - pixel[2]})
        table.insert(quarterPixels, {2 * centerX - pixel[1], 2 * centerY - pixel[2]})
    end
    for _, pixel in ipairs(quarterPixels) do
        table.insert(self.pixels, pixel)
    end
    if self.fill then
        for y = self.y1, self.y2 do
            for x = self.x1, self.x2 do
                local dx = (x - centerX) / radiusX
                local dy = (y - centerY) / radiusY
                if dx * dx + dy * dy <= 1 then
                    table.insert(self.pixels, {x, y})
                end
            end
        end
    end
end

function Circle:draw(canvas)
    self.canvas = canvas
    for _, pixel in ipairs(self.pixels) do
        local x = pixel[1]
        local y = pixel[2]
        if self.canvas[y] and self.canvas[y][x] then
            self.canvas[y][x].bgColor = self.color
            self.canvas[y][x].char = self.char
            self.canvas[y][x].charColor = self.charColor
        end
    end
end

return Circle
