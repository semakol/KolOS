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

function Dropdown:draw(canvas)
    for i = 1, self.width do
        local x = self.x + i - 1
        local y = self.y
        if canvas[y] and canvas[y][x] then
            canvas[y][x].bgColor = self.bgColor
            if i == self.width then
                canvas[y][x].char = "V"
            else
                local char = self.items[self.selectedIndex]:sub(i, i)
                canvas[y][x].char = char ~= "" and char or " "
            end
            canvas[y][x].charColor = self.textColor
        end
    end
    if self.expanded then
        local maxVisibleItems = math.min(#self.items, 5)
        for i = 1, maxVisibleItems do
            local itemIndex = i + self.scrollOffset
            local y = self.y + i
            for j = 1, self.width do
                local x = self.x + j - 1
                if canvas[y] and canvas[y][x] then
                    canvas[y][x].bgColor = self.bgColor
                    local char = self.items[itemIndex]:sub(j, j)
                    canvas[y][x].char = char ~= "" and char or " "
                    canvas[y][x].charColor = self.textColor
                end
            end
        end
    end
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