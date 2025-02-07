-- Dropdown class
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown:new(x, y, width, items, bgColor, textColor, zIndex)
    if type(x) == "table" then
        local params = x
        x = params.x
        y = params.y
        width = params.width
        items = params.items
        bgColor = params.bgColor
        textColor = params.textColor
        zIndex = params.zIndex
    end
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.width = width or 10
    obj.items = items or {}
    obj.selectedIndex = 1
    obj.expanded = false
    obj.bgColor = bgColor or colors.gray
    obj.textColor = textColor or colors.white
    obj.scrollOffset = 0
    obj.zIndex = zIndex or 0
    return obj
end

function Dropdown:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    self.frame:draw()
    return self
end

function Dropdown:setSize(width)
    self.width = width or self.width
    self.frame:draw()
    return self
end

function Dropdown:setItems(items)
    self.items = items or self.items
    self.frame:draw()
    return self
end

function Dropdown:setColors(bgColor, textColor)
    self.bgColor = bgColor or self.bgColor
    self.textColor = textColor or self.textColor
    self.frame:draw()
    return self
end

function Dropdown:setZIndex(zIndex)
    self.zIndex = zIndex or self.zIndex
    self.frame:draw()
    return self
end

function Dropdown:draw(canvas)
    local function truncateText(text, maxLength)
        if #text <= maxLength then
            return text .. string.rep(" ", maxLength - #text)
        else
            local halfLength = math.floor((maxLength - 2) / 2)
            return text:sub(1, halfLength) .. ".." .. text:sub(-halfLength)
        end
    end

    local function drawItem(x, y, text, bgColor, textColor)
        for i = 1, self.width do
            local char = text:sub(i, i) or " "
            if canvas[y] and canvas[y][x + i - 1] then
                if bgColor ~= "alpha" then
                    canvas[y][x + i - 1].bgColor = bgColor
                end
                canvas[y][x + i - 1].char = char
                canvas[y][x + i - 1].charColor = textColor
            end
        end
    end

    local selectedItem = self.items[self.selectedIndex] or ""
    local truncatedItem = truncateText(selectedItem, self.width - 1)
    drawItem(self.x, self.y, truncatedItem .. "V", self.bgColor, self.textColor)

    if self.expanded then
        local maxVisibleItems = math.min(#self.items, 5)
        local winWidth, winHeight = self.frame.win.getSize()
        local startY = self.y + 1
        if self.y + maxVisibleItems > winHeight then
            startY = self.y - maxVisibleItems
        end
        for i = 1, maxVisibleItems do
            local itemIndex = i + self.scrollOffset
            local y = startY + i - 1
            local item = self.items[itemIndex] or ""
            local truncatedItem = truncateText(item, self.width)
            drawItem(self.x, y, truncatedItem, self.bgColor, self.textColor)
        end
    end
end

function Dropdown:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my == self.y then
        self.expanded = not self.expanded
    elseif self.expanded and mx >= self.x and mx < self.x + self.width then
        local winWidth, winHeight = self.frame.win.getSize()
        local maxVisibleItems = math.min(#self.items, 5)
        local startY = self.y + 1
        if self.y + maxVisibleItems > winHeight then
            startY = self.y - maxVisibleItems
        end
        if my >= startY and my < startY + maxVisibleItems then
            self.selectedIndex = my - startY + 1 + self.scrollOffset
            self.expanded = false
        else
            self.expanded = false
        end
    else
        self.expanded = false
    end
end

function Dropdown:handleScroll(direction)
    if self.expanded then
        if direction == -1 or direction == 0 and self.scrollOffset > 0 then
            self.scrollOffset = self.scrollOffset - 1
        elseif direction == 1 and self.scrollOffset < #self.items - 5 then
            self.scrollOffset = self.scrollOffset + 1
        end
    end
end

function Dropdown:handleKey(key)
    if self.expanded then
        if key == keys.up and self.scrollOffset > 0 then
            self.scrollOffset = self.scrollOffset - 1
        elseif key == keys.down and self.scrollOffset < #self.items - 5 then
            self.scrollOffset = self.scrollOffset + 1
        elseif key == keys.enter then
            self.selectedIndex = self.scrollOffset + 1
            self.expanded = false
        end
    end
end

function Dropdown:isExpanded()
    return self.expanded
end

function Dropdown:getSelectedOption()
    return self.items[self.selectedIndex]
end

return Dropdown