local Button = {}
Button.__index = Button

-- Button class
function Button:new(x, y, label, callback, bgColor, textColor, width, height)
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.label = label or ""
    obj.callback = callback or {}
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
    return self
end

function Button:setSize(width, height)
    local winWidth, winHeight = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
    self.height = math.max(1, math.min(height, winHeight - self.y + 1))
    return self
end

function Button:setLabel(label)
    self.label = label or self.label
    return self
end

function Button:setBgColor(bgColor, textColor)
    self.bgColor = bgColor or self.bgColor
    self.textColor = textColor or self.textColor
    return self
end

function Button:addCallback(callback)
    table.insert(self.callback, callback or function() end)
    return self
end

function Button:draw(canvas)
    for i = 0, self.height - 1 do
        local y = self.y + i
        for j = 0, self.width - 1 do
            local x = self.x + j
            if canvas[y] and canvas[y][x] then
                canvas[y][x].bgColor = self.bgColor
                if i == math.floor(self.height / 2) and j >= math.floor((self.width - #self.label) / 2) and j < math.floor((self.width - #self.label) / 2) + #self.label then
                    canvas[y][x].char = self.label:sub(j - math.floor((self.width - #self.label) / 2) + 1, j - math.floor((self.width - #self.label) / 2) + 1)
                else
                    canvas[y][x].char = " "
                end
                canvas[y][x].charColor = self.textColor
            end
        end
    end
end

function Button:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my >= self.y and my < self.y + self.height then
        for _, cb in ipairs(self.callback) do
            cb()
        end
    end
end

return Button