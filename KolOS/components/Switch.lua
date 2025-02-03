local Switch = {}
Switch.__index = Switch

function Switch:new(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    local obj = setmetatable({}, self)
    obj.x = x or 0
    obj.y = y or 0
    obj.state = state or false
    obj.callback = callback
    obj.activeBgColor = activeBgColor or colors.green
    obj.inactiveBgColor = inactiveBgColor or colors.red
    obj.activeTextColor = activeTextColor or colors.white
    obj.inactiveTextColor = inactiveTextColor or colors.white
    obj.activeText = activeText or "[ON]"
    obj.inactiveText = inactiveText or "[OFF]"
    return obj
end

function Switch:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    return self
end

function Switch:setState(state)
    self.state = state
    return self
end

function Switch:setCallback(callback)
    self.callback = callback
    return self
end

function Switch:setColors(activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    self.activeBgColor = activeBgColor or self.activeBgColor
    self.inactiveBgColor = inactiveBgColor or self.inactiveBgColor
    self.activeTextColor = activeTextColor or self.activeTextColor
    self.inactiveTextColor = inactiveTextColor or self.inactiveTextColor
    return self
end

function Switch:setTexts(activeText, inactiveText)
    self.activeText = activeText or self.activeText
    self.inactiveText = inactiveText or self.inactiveText
    return self
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

return Switch
