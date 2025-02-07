-- Rect class
local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, width, height, bgColor, fill, char, charColor, zIndex)
    if type(x) == "table" then
        local params = x
        x = params.x
        y = params.y
        width = params.width
        height = params.height
        bgColor = params.bgColor
        fill = params.fill
        char = params.char
        charColor = params.charColor
        zIndex = params.zIndex
    end
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.width = width or 1
    obj.height = height or 1
    obj.bgColor = bgColor or colors.gray
    obj.fill = fill or false
    obj.char = char or " "
    obj.charColor = charColor or colors.white
    obj.zIndex = zIndex or 0
    return obj
end

function Rect:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    self.frame:draw()
    return self
end

function Rect:setSize(width, height)
    self.width = width or self.width
    self.height = height or self.height
    self.frame:draw()
    return self
end

function Rect:setColors(bgColor, charColor)
    self.bgColor = bgColor or self.bgColor
    self.charColor = charColor or self.charColor
    self.frame:draw()
    return self
end

function Rect:setChar(char)
    self.char = char or self.char
    self.frame:draw()
    return self
end

function Rect:setFill(fill)
    self.fill = fill or self.fill
    self.frame:draw()
    return self
end

function Rect:setZIndex(zIndex)
    self.zIndex = zIndex or self.zIndex
    self.frame:draw()
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