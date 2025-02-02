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

function Switch:draw(win)
    win.setCursorPos(self.x, self.y)
    if self.state then
        win.setBackgroundColor(self.activeBgColor)
        win.setTextColor(self.activeTextColor)
        win.write("[ON]")
    else
        win.setBackgroundColor(self.inactiveBgColor)
        win.setTextColor(self.inactiveTextColor)
        win.write("[OFF]")
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
