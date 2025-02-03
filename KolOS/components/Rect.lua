-- Rect class
local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, width, height, bgColor, fill, char, charColor)
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.width = width or 1
    obj.height = height or 1
    obj.bgColor = bgColor or colors.gray
    obj.fill = fill or false
    obj.char = char or " "
    obj.charColor = charColor or colors.white
    return obj
end

function Rect:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    return self
end

function Rect:setSize(width, height)
    self.width = width or self.width
    self.height = height or self.height
    return self
end

function Rect:setColors(bgColor, charColor)
    self.bgColor = bgColor or self.bgColor
    self.charColor = charColor or self.charColor
    return self
end

function Rect:setChar(char)
    self.char = char or self.char
    return self
end

function Rect:setFill(fill)
    self.fill = fill or self.fill
    return self
end

function Rect:draw(canvas)
    for i = 0, self.height - 1 do
        for j = 0, self.width - 1 do
            if self.fill or i == 0 or i == self.height - 1 or j == 0 or j == self.width - 1 then
                local x = self.x + j
                local y = self.y + i
                if canvas[y] and canvas[y][x] then
                    canvas[y][x].bgColor = self.bgColor
                    canvas[y][x].char = self.char
                    canvas[y][x].charColor = self.charColor
                end
            end
        end
    end
end

return Rect