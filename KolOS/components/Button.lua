local Button = {}
Button.__index = Button

-- Button class
function Button:new(x, y, label, callback, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.label = label
    obj.callback = callback or function() end
    obj.bgColor = bgColor or colors.gray
    obj.textColor = textColor or colors.white
    return obj
end

function Button:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Button:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Button:addCallback(callback)
    self.callback = callback or function() end
end

function Button:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    win.write("[" .. self.label .. "]")
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Button:handleClick(mx, my)
    if mx >= self.x and mx < self.x + #self.label + 2 and my == self.y then
        self.callback()
    end
end

return Button