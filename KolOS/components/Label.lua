-- Label class
local Label = {}
Label.__index = Label

function Label:new(x, y, text, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.text = text
    obj.textColor = textColor or colors.white
    return obj
end

function Label:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Label:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Label:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setTextColor(self.textColor)
    win.write(self.text)
    win.setTextColor(colors.white)
end

function Label:setText(newText)
    self.text = newText
    if self.gui then
        self.gui:draw()
    end
end

return Label