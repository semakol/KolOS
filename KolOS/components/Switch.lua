local Switch = {}
Switch.__index = Switch

function Switch:new(x, y, state, callback, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.state = state or false
    obj.callback = callback
    obj.bgColor = bgColor or colors.gray
    obj.textColor = textColor or colors.white
    return obj
end

function Switch:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    if self.state then
        win.write("[ON]")
    else
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

function Switch:handleInput(event, key)
    -- Handle keyboard input if necessary
end

return Switch
