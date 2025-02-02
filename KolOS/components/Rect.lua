-- Rect class
local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, width, height, bgColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.bgColor = bgColor or colors.gray
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

function Rect:draw(win)
    win.setBackgroundColor(self.bgColor)
    for i = 0, self.height - 1 do
        win.setCursorPos(self.x, self.y + i)
        win.write(string.rep(" ", self.width))
    end
    win.setBackgroundColor(colors.black)
end

return Rect