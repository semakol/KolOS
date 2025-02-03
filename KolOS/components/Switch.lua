local Switch = {}
Switch.__index = Switch

function Switch:new(x, y, state, callback, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.state = state or false
    obj.callback = callback
    obj.textColor = textColor or colors.white
    obj.activeBgColor = colors.green
    obj.inactiveBgColor = colors.red
    obj.activeTextColor = colors.white
    obj.inactiveTextColor = colors.white
    return obj
end

function Switch:draw(canvas)
    for i = 0, 4 do
        local x = self.x + i
        local y = self.y
        if canvas[y] and canvas[y][x] then
            if self.state then
                canvas[y][x].bgColor = self.activeBgColor
                canvas[y][x].charColor = self.activeTextColor
                canvas[y][x].char = ("[ON] "):sub(i + 1, i + 1)
            else
                canvas[y][x].bgColor = self.inactiveBgColor
                canvas[y][x].charColor = self.inactiveTextColor
                canvas[y][x].char = ("[OFF]"):sub(i + 1, i + 1)
            end
        end
    end
end

function Switch:handleClick(x, y)
    if x >= self.x and x < self.x + 4 and y == self.y then
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

return Switch
