-- Textarea class
local Textarea = {}
Textarea.__index = Textarea

function Textarea:new(x, y, width, height, bgColor, textColor)
    if type(x) == "table" then
        local params = x
        x = params.x
        y = params.y
        width = params.width
        height = params.height
        bgColor = params.bgColor
        textColor = params.textColor
    end
    local obj = setmetatable({}, self)
    obj.x = x or 1
    obj.y = y or 1
    obj.width = width or 10
    obj.height = height or 5
    obj.list = {}
    obj.textList = {}
    obj.active = false
    obj.bgColor = bgColor or colors.white
    obj.textColor = textColor or colors.black
    obj.scrollOffset = 0
    return obj
end

function Textarea:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    return self
end

function Textarea:setSize(width, height)
    self.width = width or self.width
    self.height = height or self.height
    self:updateTextList()
    return self
end

function Textarea:setColors(bgColor, textColor)
    self.bgColor = bgColor or self.bgColor
    self.textColor = textColor or self.textColor
    return self
end

function Textarea:draw(canvas)
    for i = 1, self.height do
        local y = self.y + i - 1
        local line = self.textList[i + self.scrollOffset] or ""
        for j = 1, self.width do
            local x = self.x + j - 1
            if canvas[y] and canvas[y][x] then
                canvas[y][x].bgColor = self.bgColor
                canvas[y][x].char = line:sub(j, j) ~= "" and line:sub(j, j) or " "
                canvas[y][x].charColor = self.textColor
            end
        end
    end
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
    -- if self.gui then
    --     self.gui:draw()
    -- end
    return self
end

function Textarea:addLine(line)
    table.insert(self.list, line)
    self:updateTextList()
    -- if self.gui then
    --     self.gui:draw()
    -- end
    return self
end

function Textarea:scrollUp()
    if self.scrollOffset > 0 then
        self.scrollOffset = self.scrollOffset - 1
        -- if self.gui then
        --     self.gui:draw()
        -- end
    end
end

function Textarea:scrollDown()
    if self.scrollOffset < #self.textList - self.height then
        self.scrollOffset = self.scrollOffset + 1
        -- if self.gui then
        --     self.gui:draw()
        -- end
    end
end

function Textarea:isMouseOver(mx, my)
    return mx >= self.x and mx < self.x + self.width and my >= self.y and my < self.y + self.height
end

return Textarea