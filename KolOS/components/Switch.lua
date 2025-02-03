local Switch = {}
Switch.__index = Switch

function Switch:new(x, y, state, callback, textColor, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.state = state or false
    obj.callback = callback
    obj.textColor = textColor or colors.white
    obj.activeBgColor = activeBgColor or colors.green
    obj.inactiveBgColor = inactiveBgColor or colors.red
    obj.activeTextColor = activeTextColor or colors.white
    obj.inactiveTextColor = inactiveTextColor or colors.white
    obj.activeText = activeText or "[ON]"
    obj.inactiveText = inactiveText or "[OFF]"
    return obj
end

function Switch:draw(canvas)
    self.width = self.state and #self.activeText or #self.inactiveText
    for i = 0, self.width - 1 do
        local x = self.x + i
        local y = self.y
        if canvas[y] and canvas[y][x] then
            if self.state then
                canvas[y][x].bgColor = self.activeBgColor
                canvas[y][x].charColor = self.activeTextColor
                canvas[y][x].char = self.activeText:sub(i + 1, i + 1)
            else
                canvas[y][x].bgColor = self.inactiveBgColor
                canvas[y][x].charColor = self.inactiveTextColor
                canvas[y][x].char = self.inactiveText:sub(i + 1, i + 1)
            end
        end
    end
end

function Switch:handleClick(x, y)
    if x >= self.x and x < self.x + self.width and y == self.y then
        self.state = not self.state
        if self.callback then
            self.callback(self.state)
        end
    end
end

function Switch:setColors(activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    self.activeBgColor = activeBgColor
    self.inactiveBgColor = inactiveBgColor
    self.activeTextColor = activeTextColor
    self.inactiveTextColor = inactiveTextColor
end

function Switch:setActiveText(text)
    self.activeText = text
end

function Switch:setInactiveText(text)
    self.inactiveText = text
end

return Switch
