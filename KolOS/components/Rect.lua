-- Rect class
local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, width, height, bgColor, fill, char, charColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.bgColor = bgColor or colors.gray
    obj.fill = fill or false
    obj.char = char or " "
    obj.charColor = charColor or colors.white
    return obj
end

function Rect:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Rect:setSize(width, height)
    local winWidth, winHeight = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
    self.height = math.max(1, math.min(height, winHeight - self.y + 1))
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