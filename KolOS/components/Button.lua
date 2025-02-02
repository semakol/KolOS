local Button = {}
Button.__index = Button

-- Button class
function Button:new(x, y, label, callback, bgColor, textColor, width, height)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.label = label
    obj.callback = callback or function() end
    obj.bgColor = bgColor or colors.gray
    obj.textColor = textColor or colors.white
    obj.width = width or #label + 2
    obj.height = height or 1
    return obj
end

function Button:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Button:setSize(width, height)
    local winWidth, winHeight = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
    self.height = math.max(1, math.min(height, winHeight - self.y + 1))
end

function Button:addCallback(callback)
    self.callback = callback or function() end
end

function Button:draw(win)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    for i = 0, self.height - 1 do
        win.setCursorPos(self.x, self.y + i)
        if i == math.floor(self.height / 2) then
            local padding = math.floor((self.width - #self.label) / 2)
            win.write(string.rep(" ", padding) .. self.label .. string.rep(" ", self.width - #self.label - padding))
        else
            win.write(string.rep(" ", self.width))
        end
    end
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Button:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my >= self.y and my < self.y + self.height then
        self.callback()
    end
end

return Button