-- Textarea class
local Textarea = {}
Textarea.__index = Textarea

function Textarea:new(x, y, width, height, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.height = height
    obj.list = {}
    obj.textList = {}
    obj.active = false
    obj.bgColor = bgColor or colors.white
    obj.textColor = textColor or colors.black
    obj.scrollOffset = 0
    return obj
end

function Textarea:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Textarea:setSize(width, height)
    local winWidth, winHeight = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
    self.height = math.max(1, math.min(height, winHeight - self.y + 1))
    self:updateTextList()
end

function Textarea:draw(win)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    for i = 1, self.height do
        win.setCursorPos(self.x, self.y + i - 1)
        local line = self.textList[i + self.scrollOffset] or ""
        win.write(line .. string.rep(" ", self.width - #line))
    end
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Textarea:updateTextList()
    self.textList = {}
    for _, line in ipairs(self.list) do
        while #line > self.width do
            table.insert(self.textList, line:sub(1, self.width))
            line = line:sub(self.width + 1)
        end
        table.insert(self.textList, line)
    end
    self.scrollOffset = math.max(0, #self.textList - self.height)
end

function Textarea:setText(newText)
    self.list = {}
    for line in newText:gmatch("[^\r\n]+") do
        table.insert(self.list, line)
    end
    self:updateTextList()
    if self.gui then
        self.gui:draw()
    end
end

function Textarea:addLine(line)
    table.insert(self.list, line)
    self:updateTextList()
    if self.gui then
        self.gui:draw()
    end
end

function Textarea:scrollUp()
    if self.scrollOffset > 0 then
        self.scrollOffset = self.scrollOffset - 1
        if self.gui then
            self.gui:draw()
        end
    end
end

function Textarea:scrollDown()
    if self.scrollOffset < #self.textList - self.height then
        self.scrollOffset = self.scrollOffset + 1
        if self.gui then
            self.gui:draw()
        end
    end
end

function Textarea:isMouseOver(mx, my)
    return mx >= self.x and mx < self.x + self.width and my >= self.y and my < self.y + self.height
end

return Textarea