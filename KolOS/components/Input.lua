-- Input class
local Input = {}
Input.__index = Input

function Input:new(x, y, width, maxLength, bgColor, textColor)
    local obj = setmetatable({}, self)
    obj.x = x
    obj.y = y
    obj.width = width
    obj.text = ""
    obj.active = false
    obj.cursorPos = 0
    obj.scrollOffset = 0
    obj.maxLength = maxLength or width  -- Add maxLength property
    obj.bgColor = bgColor or colors.white
    obj.textColor = textColor or colors.black
    return obj
end

function Input:setPosition(x, y)
    local winWidth, winHeight = self.gui.win.getSize()
    self.x = math.max(1, math.min(x, winWidth))
    self.y = math.max(1, math.min(y, winHeight))
end

function Input:setSize(width)
    local winWidth, _ = self.gui.win.getSize()
    self.width = math.max(1, math.min(width, winWidth - self.x + 1))
end

function Input:draw(win)
    win.setCursorPos(self.x, self.y)
    win.setBackgroundColor(self.bgColor)
    win.setTextColor(self.textColor)
    local displayText = self.text:sub(self.scrollOffset + 1, self.scrollOffset + self.width)
    win.write(displayText .. string.rep(" ", self.width - #displayText))
    if self.active then
        win.setCursorPos(self.x + self.cursorPos - self.scrollOffset, self.y)
        if self.cursorPos + 1 <= #self.text then
            win.setBackgroundColor(self.textColor)
            win.setTextColor(self.bgColor)
            win.write(self.text:sub(self.cursorPos+1, self.cursorPos+1))
        else
            win.write("_")
        end
    end
    win.setBackgroundColor(colors.black)
    win.setTextColor(colors.white)
end

function Input:handleClick(mx, my)
    if mx >= self.x and mx < self.x + self.width and my == self.y then
        self.active = true
        self.cursorPos = math.min(mx - self.x + self.scrollOffset, #self.text)
    else
        self.active = false
    end
end

function Input:handleInput(event, param)
    if self.active and event == "char" then
        if #self.text < self.maxLength then
            self.text = self.text:sub(1, self.cursorPos) .. param .. self.text:sub(self.cursorPos + 1)
            self.cursorPos = self.cursorPos + 1
            if self.cursorPos > self.scrollOffset + self.width then
                self.scrollOffset = self.scrollOffset + 1
            end
        end
    elseif self.active and event == "key" then
        if param == keys.backspace then
            if self.cursorPos > 0 then
                self.text = self.text:sub(1, self.cursorPos - 1) .. self.text:sub(self.cursorPos + 1)
                self.cursorPos = self.cursorPos - 1
                if self.cursorPos < self.scrollOffset then
                    self.scrollOffset = self.scrollOffset - 1
                end
            end
        elseif param == keys.enter then
            self.active = false
        elseif param == keys.left then
            if self.cursorPos > 0 then
                self.cursorPos = self.cursorPos - 1
                if self.cursorPos < self.scrollOffset then
                    self.scrollOffset = self.scrollOffset - 1
                end
            end
        elseif param == keys.right then
            if self.cursorPos < #self.text then
                self.cursorPos = self.cursorPos + 1
                if self.cursorPos > self.scrollOffset + self.width then
                    self.scrollOffset = self.scrollOffset + 1
                end
            end
        end
    end
end

return Input