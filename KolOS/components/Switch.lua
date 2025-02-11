local Switch = {}
Switch.__index = Switch

function Switch:new(x, y, state, callback, activeText, inactiveText, activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor, zIndex, width, height)
    if type(x) == "table" then
        local params = x
        x = params.x
        y = params.y
        state = params.state
        callback = params.callback
        activeText = params.activeText
        inactiveText = params.inactiveText
        activeBgColor = params.activeBgColor
        inactiveBgColor = params.inactiveBgColor
        activeTextColor = params.activeTextColor
        inactiveTextColor = params.inactiveTextColor
        zIndex = params.zIndex
        width = params.width
        height = params.height
    end
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
    obj.zIndex = zIndex or 0
    obj.width = width or math.max(#obj.activeText, #obj.inactiveText)
    obj.height = height or 1
    return obj
end

function Switch:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
    self.frame:draw()
    return self
end

function Switch:setState(state)
    self.state = state
    self.frame:draw()
    return self
end

function Switch:setCallback(callback)
    self.callback = callback
    self.frame:draw()
    return self
end

function Switch:setColors(activeBgColor, inactiveBgColor, activeTextColor, inactiveTextColor)
    self.activeBgColor = activeBgColor or self.activeBgColor
    self.inactiveBgColor = inactiveBgColor or self.inactiveBgColor
    self.activeTextColor = activeTextColor or self.activeTextColor
    self.inactiveTextColor = inactiveTextColor or self.inactiveTextColor
    self.frame:draw()
    return self
end

function Switch:setTexts(activeText, inactiveText)
    self.activeText = activeText or self.activeText
    self.inactiveText = inactiveText or self.inactiveText
    self.frame:draw()
    return self
end

function Switch:setZIndex(zIndex)
    self.zIndex = zIndex or self.zIndex
    self.frame:draw()
    return self
end

function Switch:setSize(width, height)
    self.width = width or self.width
    self.height = height or self.height
    self.frame:draw()
    return self
end

function Switch:draw(canvas)
    local text = self.state and self.activeText or self.inactiveText
    local textLength = #text
    local padding = math.floor((self.width - textLength) / 2)
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            local canvasX = self.x + x
            local canvasY = self.y + y
            if canvas[canvasY] and canvas[canvasY][canvasX] then
                if self.state then
                    if self.activeBgColor ~= "alpha" then
                        canvas[canvasY][canvasX].bgColor = self.activeBgColor
                    end
                    canvas[canvasY][canvasX].charColor = self.activeTextColor
                else
                    if self.inactiveBgColor ~= "alpha" then
                        canvas[canvasY][canvasX].bgColor = self.inactiveBgColor
                    end
                    canvas[canvasY][canvasX].charColor = self.inactiveTextColor
                end
                if y == math.floor(self.height / 2) and x >= padding and x < padding + textLength then
                    canvas[canvasY][canvasX].char = text:sub(x - padding + 1, x - padding + 1)
                else
                    canvas[canvasY][canvasX].char = " "
                end
            end
        end
    end
end

function Switch:handleClick(x, y)
    if x >= self.x and x < self.x + self.width and y >= self.y and y < self.y + self.height then
        self.state = not self.state
        if self.callback then
            self.callback(self.state)
        end
    end
end

function Switch:setParams(params)
    if params.x then self.x = params.x end
    if params.y then self.y = params.y end
    if params.state ~= nil then self.state = params.state end
    if params.callback then self.callback = params.callback end
    if params.activeText then self.activeText = params.activeText end
    if params.inactiveText then self.inactiveText = params.inactiveText end
    if params.activeBgColor then self.activeBgColor = params.activeBgColor end
    if params.inactiveBgColor then self.inactiveBgColor = params.inactiveBgColor end
    if params.activeTextColor then self.activeTextColor = params.activeTextColor end
    if params.inactiveTextColor then self.inactiveTextColor = params.inactiveTextColor end
    if params.zIndex then self.zIndex = params.zIndex end
    if params.width then self.width = params.width end
    if params.height then self.height = params.height end
    self.frame:draw()
    return self
end

return Switch
