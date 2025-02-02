-- Dropdown class
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown:new(x, y, width, items, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.items = items or {}
    obj.selectedIndex = 1
    obj.expanded = false
    obj.bgColor = bgColor or colors.gray
    obj.textColor = textColor or colors.white
    obj.scrollOffset = 0
    return obj
end

function Dropdown:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Dropdown:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Dropdown:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    local displayText = self.items[self.selectedIndex] .. string.rep(" ", self.width - #self.items[self.selectedIndex] - 1) .. "V"
    win.write(displayText)
    if self.expanded then
        local winWidth, winHeight = self.gui.win.getSize()
        local maxVisibleItems = math.min(#self.items, 5)
        local startY = self.y + 1
        if self.y + maxVisibleItems > winHeight then
            startY = self.y - maxVisibleItems
        end
        for i = 1, maxVisibleItems do
            win.setCursorPos(self.x, startY + i - 1)
            local itemIndex = i + self.scrollOffset
            win.write(self.items[itemIndex] .. string.rep(" ", self.width - #self.items[itemIndex]))
        end
    end
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Dropdown:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my == self.y then
        self.expanded = not self.expanded
    elseif self.expanded and mx >= self.x and mx < self.x + self.width then
        local winWidth, winHeight = self.gui.win.getSize()
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
        if direction == 0 and self.scrollOffset > 0 then
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